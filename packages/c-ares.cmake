ExternalProject_Add(c-ares
    GIT_SHALLOW TRUE
    GIT_REPOSITORY https://github.com/c-ares/c-ares.git
    SOURCE_DIR ${SOURCE_LOCATION}
    UPDATE_COMMAND ""
    GIT_REMOTE_NAME origin
    GIT_TAG main
    CONFIGURE_COMMAND ${EXEC} cmake -B <BINARY_DIR> -S <SOURCE_DIR>
        ${EP_CMAKE_ARGS}
        -DBUILD_SHARED_LIBS=OFF
        -DCARES_BUILD_TESTS=OFF
        -DCARES_BUILD_TOOLS=OFF
        -DCARES_INSTALL=ON
        -DCARES_SHARED=OFF
        -DCARES_STATIC=ON
        -DCARES_THREADS=ON
    BUILD_COMMAND ${EXEC} ninja
    INSTALL_COMMAND ${EXEC} ninja install
    ${EP_LOG_ARGS}
)

cleanup(c-ares install)
