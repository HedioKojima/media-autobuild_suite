ExternalProject_Add(vulkan-header
    GIT_SHALLOW TRUE
    GIT_REPOSITORY https://github.com/KhronosGroup/Vulkan-Headers.git
    SOURCE_DIR ${SOURCE_LOCATION}
    UPDATE_COMMAND ""
    GIT_REMOTE_NAME origin
    GIT_TAG main
    CONFIGURE_COMMAND ""
    BUILD_COMMAND ""
    INSTALL_COMMAND ""
    ${EP_LOG_ARGS}
)
cleanup(vulkan-header install)
