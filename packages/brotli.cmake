ExternalProject_Add(brotli
    GIT_REPOSITORY https://github.com/google/brotli.git
    SOURCE_DIR ${SOURCE_LOCATION}
    GIT_SHALLOW TRUE
    UPDATE_COMMAND ""
    CONFIGURE_COMMAND ${EXEC} cmake -B <BINARY_DIR> -S <SOURCE_DIR>
        ${EP_CMAKE_ARGS}
        -DBUILD_SHARED_LIBS=OFF
        -DBROTLI_EMSCRIPTEN=OFF
        -DBROTLI_BUILD_TOOLS=OFF
    BUILD_COMMAND ${EXEC} ninja
    INSTALL_COMMAND ${EXEC} ninja install
    ${EP_LOG_ARGS}
)

cleanup(brotli install)
