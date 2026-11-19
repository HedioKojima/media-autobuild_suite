ExternalProject_Add(ngtcp2
    DEPENDS
        openssl
    GIT_REPOSITORY https://github.com/ngtcp2/ngtcp2.git
    SOURCE_DIR ${SOURCE_LOCATION}
    GIT_SHALLOW TRUE
    GIT_SUBMODULES ""
    GIT_TAG main
    UPDATE_COMMAND ""
    CONFIGURE_COMMAND ${EXEC} cmake -B <BINARY_DIR> -S <SOURCE_DIR>
        ${EP_CMAKE_ARGS}
        -DBUILD_SHARED_LIBS=OFF
        -DBUILD_TESTING=OFF
        -DENABLE_BORINGSSL=OFF
        -DENABLE_GNUTLS=OFF
        -DENABLE_JEMALLOC=OFF
        -DENABLE_LIB_ONLY=ON
        -DENABLE_OPENSSL=ON
        -DENABLE_PICOTLS=OFF
        -DENABLE_SHARED_LIB=OFF
        -DENABLE_STATIC_LIB=ON
        -DENABLE_WOLFSSL=OFF
        "-DCMAKE_EXE_LINKER_FLAGS='-lbrotlicommon -lbrotlidec -lbrotlienc -lz -lzstd'"
    BUILD_COMMAND ${EXEC} ninja
    INSTALL_COMMAND ${EXEC} ninja install
    ${EP_LOG_ARGS}
)

cleanup(ngtcp2 install)
