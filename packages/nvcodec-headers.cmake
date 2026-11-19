ExternalProject_Add(nvcodec-headers
    GIT_SHALLOW TRUE
    GIT_REPOSITORY https://github.com/FFmpeg/nv-codec-headers.git
    SOURCE_DIR ${SOURCE_LOCATION}
    UPDATE_COMMAND ""
    CONFIGURE_COMMAND ""
    BUILD_COMMAND ""
    INSTALL_COMMAND ${MAKE} -C <SOURCE_DIR>
        PREFIX=${MINGW_INSTALL_PREFIX}
        install
    ${EP_LOG_ARGS}
)

cleanup(nvcodec-headers install)
