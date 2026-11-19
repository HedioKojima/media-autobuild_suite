ExternalProject_Add(fast_float
    GIT_SHALLOW TRUE
    GIT_REPOSITORY https://github.com/fastfloat/fast_float.git
    SOURCE_DIR ${SOURCE_LOCATION}
    GIT_REMOTE_NAME origin
    GIT_TAG main
    UPDATE_COMMAND ""
    CONFIGURE_COMMAND ""
    BUILD_COMMAND ""
    INSTALL_COMMAND ""
    ${EP_LOG_ARGS}
)

cleanup(fast_float install)
