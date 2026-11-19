ExternalProject_Add(spirv-headers
    GIT_SHALLOW TRUE
    GIT_REPOSITORY https://github.com/KhronosGroup/SPIRV-Headers.git
    SOURCE_DIR ${SOURCE_LOCATION}
    GIT_REMOTE_NAME origin
    GIT_TAG main
    UPDATE_COMMAND ""
    CONFIGURE_COMMAND ${EXEC} cmake -B <BINARY_DIR> -S <SOURCE_DIR>
        ${EP_CMAKE_ARGS}
    BUILD_COMMAND ""
    INSTALL_COMMAND ${EXEC} ninja install
    ${EP_LOG_ARGS}
)

cleanup(spirv-headers install)
