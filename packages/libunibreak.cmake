# git 源需要现场生成 configure（仓库里只有 configure.ac + autogen.sh）。
# MSYS2 的 automake/aclocal 在 Windows 绝对路径下会算丢盘符
# （报 /a/_temp/msys64/usr/share/aclocal/progtest.m4 不存在），所以：
#   1. exec.in 里导出 ACLOCAL_PATH=/usr/share/aclocal，aclocal 多一条 posix 搜索路径
#   2. PATCH 里先 cd 到 cygpath -u 后的 posix 路径再 autoreconf，$0 全程不带盘符
ExternalProject_Add(libunibreak
    GIT_REPOSITORY https://github.com/adah1972/libunibreak.git
    GIT_TAG libunibreak_8_0_1
    GIT_SHALLOW TRUE
    SOURCE_DIR ${SOURCE_LOCATION}
    GIT_REMOTE_NAME origin
    UPDATE_COMMAND ""
    PATCH_COMMAND ${EXEC} "cd $(cygpath -u <SOURCE_DIR>) && autoreconf -fi"
    CONFIGURE_COMMAND ${EXEC} ./configure
        --build=${TARGET_CPU}-w64-mingw32
        --prefix=${MINGW_INSTALL_PREFIX}
        --disable-shared
    BUILD_COMMAND ${MAKE}
    INSTALL_COMMAND ${MAKE} install
    BUILD_IN_SOURCE 1
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_PATCH 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

cleanup(libunibreak install)
