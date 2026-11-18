cmake_minimum_required(VERSION 3.19.0)
project(mpv-win NONE)

include(ProcessorCount)
include(${CMAKE_CURRENT_SOURCE_DIR}/cmake/download_externalproject.cmake)
include(${CMAKE_CURRENT_SOURCE_DIR}/cmake/custom_steps.cmake)

cmake_policy(SET CMP0097 NEW)
cmake_policy(SET CMP0114 NEW)
if(POLICY CMP0135)
  cmake_policy(SET CMP0135 NEW)
endif()

if(NOT CMAKE_GENERATOR STREQUAL "Ninja")
    message(WARNING "Generator \"${CMAKE_GENERATOR}\" is unsupported!\nUse Ninja.")
endif()

# This build is a native MSYS2 clang64 build: no cross compiler, no sysroot,
# everything is installed into the clang64 prefix and linked statically.
set(TARGET_ARCH "x86_64-w64-mingw32" CACHE STRING "Triple used for naming/FFmpeg target-os.")
string(REGEX MATCH "^[^-]+" TARGET_CPU ${TARGET_ARCH})
set(TARGET_CPU_FAMILY "x86_64")
set(GCC_ARCH "x86-64-v3" CACHE STRING "Value for -march/-mtune and Rust target-cpu (znver3 etc. for a fixed CPU)")

processorcount(CPU_COUNT)
if(CPU_COUNT EQUAL 0)
    set(CPU_COUNT 1)
endif()
set(MAKEJOBS ${CPU_COUNT})

if(CMAKE_INSTALL_PREFIX_INITIALIZED_TO_DEFAULT)
    set(CMAKE_INSTALL_PREFIX "${CMAKE_CURRENT_BINARY_DIR}/install" CACHE PATH "Default install path" FORCE)
endif()

# MSYS2 clang64 prefix (usually C:/msys64/clang64). Pass -DMINGW_INSTALL_PREFIX=
# explicitly, or let it fall back to $MINGW_PREFIX / /clang64.
if(NOT MINGW_INSTALL_PREFIX)
    if(DEFINED ENV{MINGW_PREFIX} AND NOT "$ENV{MINGW_PREFIX}" STREQUAL "")
        set(MINGW_INSTALL_PREFIX "$ENV{MINGW_PREFIX}" CACHE STRING "MSYS2 clang64 install prefix")
    else()
        set(MINGW_INSTALL_PREFIX "/clang64" CACHE STRING "MSYS2 clang64 install prefix")
    endif()
endif()
set(SINGLE_SOURCE_LOCATION "" CACHE STRING "Repository or tarball stored path")

option(ENABLE_CCACHE "Enable ccache" ON)
set(CCACHE_DIR "${CMAKE_CURRENT_BINARY_DIR}/ccache" CACHE STRING "Directory to keep ccached data")
configure_file(${CMAKE_CURRENT_SOURCE_DIR}/ccache_conf.in ${CCACHE_DIR}/ccache.conf @ONLY)
find_program(CCACHE_EXISTS ccache NO_CACHE)
if(NOT CCACHE_EXISTS)
    set(ENABLE_CCACHE OFF)
endif()

configure_file(${CMAKE_CURRENT_SOURCE_DIR}/toolchain.cmake.in ${CMAKE_CURRENT_BINARY_DIR}/toolchain.cmake @ONLY)
set(TOOLCHAIN_FILE ${CMAKE_CURRENT_BINARY_DIR}/toolchain.cmake)

configure_file(${CMAKE_CURRENT_SOURCE_DIR}/meson_native.ini.in ${CMAKE_CURRENT_BINARY_DIR}/meson_native.ini @ONLY)
set(MESON_NATIVE ${CMAKE_CURRENT_BINARY_DIR}/meson_native.ini)

configure_file(${CMAKE_CURRENT_SOURCE_DIR}/exec.in ${CMAKE_CURRENT_BINARY_DIR}/exec
               FILE_PERMISSIONS OWNER_READ OWNER_WRITE OWNER_EXECUTE GROUP_READ GROUP_EXECUTE WORLD_READ WORLD_EXECUTE @ONLY)
set(EXEC ${CMAKE_CURRENT_BINARY_DIR}/exec)
set(MAKE ${EXEC} make -j${MAKEJOBS})

message(STATUS "MINGW_INSTALL_PREFIX dir: ${MINGW_INSTALL_PREFIX}")
message(STATUS "SINGLE_SOURCE_LOCATION dir: ${SINGLE_SOURCE_LOCATION}")
message(STATUS "Target architecture: ${TARGET_ARCH} (-march=${GCC_ARCH})")
message(STATUS "Ccache: ${ENABLE_CCACHE} (${CCACHE_DIR})")

add_subdirectory(packages)
