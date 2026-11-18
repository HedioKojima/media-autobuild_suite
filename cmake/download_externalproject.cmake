# Fetch the CMake v3.31.6 ExternalProject module (main file + helper scripts)
# and apply our patch (GIT_CLONE_FLAGS, GIT_CLONE_POST_COMMAND, GIT_RESET).
#
# The original version queried the GitHub contents API with an invalid
# X-GitHub-Api-Version header, so the jq/xargs pipeline silently produced an
# empty URL list and the include of ExternalProject.cmake failed. The filenames
# below are fixed for this tag, so no API call and no rate limit is involved.
set(version "v3.31.6")
set(base "https://raw.githubusercontent.com/Kitware/CMake/${version}")
set(ep_root "${CMAKE_CURRENT_BINARY_DIR}/cmake")
set(ep_dir "${ep_root}/Modules/ExternalProject")
set(ep_file "${ep_root}/Modules/ExternalProject.cmake")
set(ep_marker "${ep_root}/.externalproject_patched")

if(NOT EXISTS "${ep_file}")
    message(STATUS "Fetching CMake ${version} ExternalProject module")
    file(MAKE_DIRECTORY "${ep_dir}")
    foreach(f gitclone.cmake.in gitupdate.cmake.in shared_internal_commands.cmake)
        execute_process(
            COMMAND curl -fsSL -o "${ep_dir}/${f}" "${base}/Modules/ExternalProject/${f}"
            RESULT_VARIABLE rv)
        if(NOT rv EQUAL 0 OR NOT EXISTS "${ep_dir}/${f}")
            message(FATAL_ERROR "Failed to download Modules/ExternalProject/${f} (exit ${rv})")
        endif()
    endforeach()
    execute_process(
        COMMAND curl -fsSL -o "${ep_file}" "${base}/Modules/ExternalProject.cmake"
        RESULT_VARIABLE rv)
    if(NOT rv EQUAL 0 OR NOT EXISTS "${ep_file}")
        message(FATAL_ERROR "Failed to download Modules/ExternalProject.cmake (exit ${rv})")
    endif()
endif()

if(NOT EXISTS "${ep_marker}")
    execute_process(
        COMMAND patch -p1 -i "${CMAKE_CURRENT_SOURCE_DIR}/packages/cmake-0001-ExternalProject-changes.patch"
        WORKING_DIRECTORY "${ep_root}"
        RESULT_VARIABLE rv
        OUTPUT_VARIABLE patch_out
        ERROR_VARIABLE patch_err)
    if(NOT rv EQUAL 0)
        message(FATAL_ERROR "patching ExternalProject failed (exit ${rv})\n${patch_out}\n${patch_err}")
    endif()
    file(WRITE "${ep_marker}" "patched ${version}\n")
endif()

include(${ep_file})
