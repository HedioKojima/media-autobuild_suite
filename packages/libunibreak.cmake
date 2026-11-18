# Use the official release tarball instead of git + autogen.sh: the git tree has
# no configure script, and re-running autoreconf inside MSYS2 breaks aclocal's
# own path resolution ("/a/_temp/msys64/usr/share/aclocal/progtest.m4" - the
# drive letter is lost). The dist tarball ships configure/ltmain.sh/config.guess
# in the top directory, so a plain in-source ./configure is enough.
ExternalProject_Add(libunibreak
    URL https://github.com/adah1972/libunibreak/releases/download/libunibreak_8_0_1/libunibreak-8.0.1.tar.gz
    URL_HASH SHA256=ac0dcc96c395bc86ff7f86f6b91d8b45bc8c39db775f3f1e73f947a11520737b
    DOWNLOAD_DIR ${SOURCE_LOCATION}
    PATCH_COMMAND ${EXEC} "find . -name Makefile.in -exec touch {} + ; find . -name aclocal.m4 -exec touch {} + ; find . -name configure -exec touch {} + ; find . -name config.status -exec touch {} +"
    CONFIGURE_COMMAND ${EXEC} ./configure
        --build=${TARGET_CPU}-w64-mingw32
        --prefix=${MINGW_INSTALL_PREFIX}
        --disable-shared
    BUILD_COMMAND ${MAKE}
    INSTALL_COMMAND ${MAKE} install
    BUILD_IN_SOURCE 1
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

cleanup(libunibreak install)
