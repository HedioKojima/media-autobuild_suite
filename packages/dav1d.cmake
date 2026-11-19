ExternalProject_Add(dav1d
    GIT_SHALLOW TRUE
    GIT_REPOSITORY https://github.com/videolan/dav1d.git
    SOURCE_DIR ${SOURCE_LOCATION}
    UPDATE_COMMAND ""
    CONFIGURE_COMMAND ${EXEC} meson setup <BINARY_DIR> <SOURCE_DIR>
        --native-file=${MESON_NATIVE}
        -Denable_tools=false
        -Denable_tests=false
        -Dxxhash_muxer=disabled
    BUILD_COMMAND ${EXEC} ninja
    INSTALL_COMMAND ${EXEC} ninja install
    ${EP_LOG_ARGS}
)

force_meson_configure(dav1d)
cleanup(dav1d install)
