# libunibreak 上游只带 autotools（仓库里没有 configure，只能 autoreconf），
# 但 src/Makefile.gcc 是官方给 Windows 准备的手写 makefile：直接 $(CC) 编 9 个
# .c 打成 ReleaseDir/libunibreak.a，不碰 configure/aclocal/automake。
# MSYS2 的 automake 在 Windows 绝对路径下会算丢盘符
# （报 /a/_temp/msys64/usr/share/aclocal/progtest.m4 不存在），所以干脆不用 autotools。
set(DOLLAR "$")
set(LIBUNIBREAK_PC ${CMAKE_CURRENT_BINARY_DIR}/libunibreak.pc)
file(WRITE ${LIBUNIBREAK_PC}
"prefix=${MINGW_INSTALL_PREFIX}
exec_prefix=${DOLLAR}{prefix}
libdir=${DOLLAR}{exec_prefix}/lib
includedir=${DOLLAR}{prefix}/include

Name: libunibreak
Description: Unicode line breaking and word breaking
Version: 8.0.1
Libs: -L${DOLLAR}{libdir} -lunibreak
Cflags: -I${DOLLAR}{includedir}
")

ExternalProject_Add(libunibreak
    GIT_REPOSITORY https://github.com/adah1972/libunibreak.git
    GIT_TAG master
    GIT_SHALLOW TRUE
    SOURCE_DIR ${SOURCE_LOCATION}
    GIT_REMOTE_NAME origin
    UPDATE_COMMAND ""
    CONFIGURE_COMMAND ""
    BUILD_COMMAND ${EXEC} "cd <SOURCE_DIR>/src && make -f Makefile.gcc CFG=Release CC=clang AR=llvm-ar CFLAGS='-W -Wall -I. -march=${GCC_ARCH} -ffunction-sections -fdata-sections' RELFLAGS='-DNDEBUG -O3'"
    INSTALL_COMMAND ${EXEC} "mkdir -p ${MINGW_INSTALL_PREFIX}/lib ${MINGW_INSTALL_PREFIX}/lib/pkgconfig ${MINGW_INSTALL_PREFIX}/include"
            COMMAND ${EXEC} "cp <SOURCE_DIR>/src/ReleaseDir/libunibreak.a ${MINGW_INSTALL_PREFIX}/lib/"
            COMMAND ${EXEC} "cd <SOURCE_DIR>/src && cp *.h ${MINGW_INSTALL_PREFIX}/include/"
            COMMAND ${EXEC} "cp ${LIBUNIBREAK_PC} ${MINGW_INSTALL_PREFIX}/lib/pkgconfig/libunibreak.pc"
    BUILD_IN_SOURCE 1
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

cleanup(libunibreak install)
