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
    get_property(_git_repository TARGET ${_name} PROPERTY _EP_GIT_REPOSITORY)

    if(_build_in_source AND _git_repository)
        # git 源码就地构建：清掉未跟踪文件再回到当前 HEAD
        set(remove_cmd "git -C <SOURCE_DIR> clean -dfx")
        set(reset_cmd "git -C <SOURCE_DIR> reset --hard -q")
    elseif(_build_in_source)
        # 就地构建的发行包（没有 .git）：删掉解包内容，让 download 重新解包
        set(remove_cmd "find <SOURCE_DIR> -mindepth 1 -delete")
        set(reset_cmd "true")
    else()
        set(remove_cmd "find <BINARY_DIR> -mindepth 1 -delete")
        set(reset_cmd "true")
    endif()

    # 一个包只留一个手工目标：删掉所有 stamp + 清构建目录，让下一次 ninja 从头来
    ExternalProject_Add_Step(${_name} fullclean
        COMMAND ${EXEC} find <LOG_DIR> -type f ! -iname "*.cmake" -size 0c -delete
        COMMAND ${EXEC} ${remove_cmd}
        COMMAND ${EXEC} ${reset_cmd}
        ALWAYS TRUE
        EXCLUDE_FROM_MAIN TRUE
        INDEPENDENT TRUE
        LOG 1
        COMMENT "Deleting all stamp files and build dir of ${_name}"
    )
    ExternalProject_Add_StepTargets(${_name} fullclean)
endfunction()

function(force_meson_configure _name)
    ExternalProject_Add_Step(${_name} force-meson-configure
        DEPENDERS configure
        COMMAND ${EXEC} rm -rf <BINARY_DIR>/meson-*
        LOG 1
    )
endfunction()
