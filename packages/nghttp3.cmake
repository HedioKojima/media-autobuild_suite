ExternalProject_Add(nghttp3
    GIT_REPOSITORY https://github.com/ngtcp2/nghttp3.git
    SOURCE_DIR ${SOURCE_LOCATION}
    GIT_SHALLOW TRUE
    GIT_SUBMODULES lib/sfparse
    GIT_TAG main
    UPDATE_COMMAND ""
    CONFIGURE_COMMAND ${EXEC} cmake -B <BINARY_DIR> -S <SOURCE_DIR>
        ${EP_CMAKE_ARGS}
        -DBUILD_SHARED_LIBS=OFF
        -DBUILD_TESTING=OFF
        -DENABLE_LIB_ONLY=ON
        -DENABLE_SHARED_LIB=OFF
        -DENABLE_STATIC_LIB=ON
    BUILD_COMMAND ${EXEC} ninja
    INSTALL_COMMAND ${EXEC} ninja install
    ${EP_LOG_ARGS}
)

cleanup(nghttp3 install)
