# ExternalProject helpers, rewritten for a NATIVE Windows (MSYS2 clang64) build.
#
# The upstream mpv-win version of this file contains a lot of Linux-oriented
# housekeeping (postremovebuild / reset_head.sh / `git restore .` / `find
# -delete`) that runs *inside* the normal build chain. On Windows those steps
# were the single biggest source of failures: there is no shebang execution,
# `git restore .` inside a shallow clone aborts the whole build, and every extra
# git invocation costs seconds per package.
#
# Here every step that is not needed to produce mpv.exe is turned into an
# explicit, manually triggered target (EXCLUDE_FROM_MAIN + INDEPENDENT), and
# every command goes through ${EXEC} (MSYS2 bash), never through cmd.exe.

function(cleanup _name _last_step)
    get_property(_build_in_source TARGET ${_name} PROPERTY _EP_BUILD_IN_SOURCE)
    get_property(source_dir TARGET ${_name} PROPERTY _EP_SOURCE_DIR)

    if(_build_in_source)
        set(remove_cmd "git -C <SOURCE_DIR> clean -dfx")
    else()
        set(remove_cmd "find <BINARY_DIR> -mindepth 1 -delete")
    endif()

    # Drop the stamp files so that the next build really starts over.
    ExternalProject_Add_Step(${_name} fullclean
        COMMAND ${EXEC} find <LOG_DIR> -type f ! -iname "*.cmake" -size 0c -delete
        COMMAND ${EXEC} ${remove_cmd}
        COMMAND ${EXEC} git -C <SOURCE_DIR> reset --hard -q
        ALWAYS TRUE
        EXCLUDE_FROM_MAIN TRUE
        INDEPENDENT TRUE
        LOG 1
        COMMENT "Deleting all stamp files and build dir of ${_name}"
    )

    ExternalProject_Add_Step(${_name} liteclean
        COMMAND ${EXEC} rm -f <LOG_DIR>/${_name}-build <LOG_DIR>/${_name}-install ${_name}-configure
        ALWAYS TRUE
        EXCLUDE_FROM_MAIN TRUE
        INDEPENDENT TRUE
        LOG 1
        COMMENT "Deleting build and install stamp files of ${_name}"
    )

    ExternalProject_Add_Step(${_name} removeprefix
        COMMAND ${EXEC} rm -rf <INSTALL_DIR> ${source_dir}
        ALWAYS TRUE
        EXCLUDE_FROM_MAIN TRUE
        INDEPENDENT TRUE
        LOG 1
        COMMENT "Deleting install prefix and source tree of ${_name}"
    )

    ExternalProject_Add_StepTargets(${_name} fullclean liteclean removeprefix)
endfunction()

# `ninja -C build update` refreshes the git checkouts; it is not part of the
# build (CI clones the tip of every repository anyway).
function(force_rebuild_git _name)
    ExternalProject_Add_Step(${_name} force-update
        ALWAYS TRUE
        EXCLUDE_FROM_MAIN TRUE
        INDEPENDENT TRUE
        WORKING_DIRECTORY <SOURCE_DIR>
        COMMAND ${EXEC} git fetch --no-recurse-submodules
        COMMAND ${EXEC} git reset --hard -q @{u}
    )
    ExternalProject_Add_StepTargets(${_name} force-update)
endfunction()

function(force_meson_configure _name)
    ExternalProject_Add_Step(${_name} force-meson-configure
        DEPENDERS configure
        COMMAND ${EXEC} rm -rf <BINARY_DIR>/meson-*
        LOG 1
    )
endfunction()
