# Provide CMake v3.31.6's ExternalProject module (main file + the whole
# Modules/ExternalProject script directory) and apply our patch
# (GIT_CLONE_FLAGS / GIT_CLONE_POST_COMMAND / GIT_RESET).
#
# The original version listed the directory through the GitHub contents API with
# an invalid X-GitHub-Api-Version header: the API answered 400, jq produced an
# empty list, xargs ran curl without a URL and the module ended up missing.
# Here the pinned source tarball is unpacked instead - one request, complete
# directory, no API and no rate limit.
set(version "v3.31.6")
set(base "https://github.com/Kitware/CMake/archive/refs/tags")
set(ep_root "${CMAKE_CURRENT_BINARY_DIR}/cmake")
set(ep_dir "${ep_root}/Modules/ExternalProject")
set(ep_file "${ep_root}/Modules/ExternalProject.cmake")
set(ep_marker "${ep_root}/.externalproject_patched")
set(ep_tarball "${ep_root}/cmake-${version}.tar.gz")

if(NOT EXISTS "${ep_file}" OR NOT EXISTS "${ep_dir}/mkdirs.cmake.in")
    message(STATUS "Fetching CMake ${version} ExternalProject module")
    file(MAKE_DIRECTORY "${ep_root}")
    execute_process(
        COMMAND curl -fsSL -o "${ep_tarball}" "${base}/${version}.tar.gz"
        RESULT_VARIABLE rv)
    if(NOT rv EQUAL 0 OR NOT EXISTS "${ep_tarball}")
        message(FATAL_ERROR "Failed to download CMake ${version} tarball (exit ${rv})")
    endif()
    execute_process(
        COMMAND tar -xzf "${ep_tarball}" --strip-components=1 --wildcards "CMake-*/Modules/ExternalProject*"
        WORKING_DIRECTORY "${ep_root}"
        RESULT_VARIABLE rv
        OUTPUT_VARIABLE tar_out
        ERROR_VARIABLE tar_err)
    if(NOT rv EQUAL 0)
        message(FATAL_ERROR "Failed to unpack ExternalProject module (exit ${rv})\n${tar_err}")
    endif()
    file(REMOVE "${ep_tarball}")
    foreach(f ExternalProject.cmake ExternalProject/mkdirs.cmake.in
              ExternalProject/shared_internal_commands.cmake ExternalProject/gitclone.cmake.in)
        if(NOT EXISTS "${ep_root}/Modules/${f}")
            message(FATAL_ERROR "Unpacked module is incomplete: Modules/${f} missing")
        endif()
    endforeach()
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
