ExternalProject_Add(libarchive
    DEPENDS
        xz
        zlib
        zstd
        libiconv
    GIT_SHALLOW TRUE
    GIT_REPOSITORY https://github.com/libarchive/libarchive.git
    SOURCE_DIR ${SOURCE_LOCATION}
    UPDATE_COMMAND ""
    CONFIGURE_COMMAND ${EXEC} cmake -B <BINARY_DIR> -S <SOURCE_DIR>
        ${EP_CMAKE_ARGS}
        -DCMAKE_INSTALL_LIBDIR=lib
        -DBUILD_SHARED_LIBS=OFF
        -DENABLE_ZLIB=ON
        -DENABLE_ZSTD=ON
        -DENABLE_OPENSSL=OFF
        -DENABLE_BZip2=OFF
        -DENABLE_ICONV=ON
        -DENABLE_LIBXML2=OFF
        -DENABLE_EXPAT=OFF
        -DENABLE_LZO=OFF
        -DENABLE_WIN32_XMLLITE=OFF
        -DENABLE_PCREPOSIX=OFF
        -DENABLE_PCRE2POSIX=OFF
        -DENABLE_LZ4=OFF
        -DENABLE_LIBB2=OFF
        -DENABLE_LZMA=ON
        -DENABLE_CPIO=OFF
        -DENABLE_CNG=ON
        -DENABLE_CAT=OFF
        -DENABLE_TAR=OFF
        -DENABLE_ACL=OFF
        -DENABLE_WERROR=OFF
        -DBUILD_TESTING=OFF
        -DENABLE_TEST=OFF
        -DWINDOWS_VERSION=WIN10
        -DPOSIX_REGEX_LIB=OFF
    BUILD_COMMAND ${EXEC} ninja
    INSTALL_COMMAND ${EXEC} ninja install
    ${EP_LOG_ARGS}
)

cleanup(libarchive install)
