# autotools note (Windows): configure must be started as "./configure" from
# inside the source tree. With an absolute Windows path ($0 = D:/...) autoconf's
# auxiliary-file lookup breaks on the drive letter and aborts with
# "cannot find required auxiliary files: config.rpath ltmain.sh ...".
ExternalProject_Add(libiconv
    URL https://www.mirrorservice.org/sites/ftp.gnu.org/gnu/libiconv/libiconv-1.19.1.tar.gz
    URL_HASH SHA256=9a06844846d664d7122161700c10a64480d7c7bcead3091925a785b38c91edab
    DOWNLOAD_DIR ${SOURCE_LOCATION}
    CONFIGURE_COMMAND ${EXEC} ./configure
        --build=${TARGET_CPU}-w64-mingw32
        --prefix=${MINGW_INSTALL_PREFIX}
        --disable-nls
        --disable-shared
        --enable-extra-encodings
    BUILD_COMMAND ${MAKE}
    INSTALL_COMMAND ${MAKE} install
    BUILD_IN_SOURCE 1
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

cleanup(libiconv install)
