ExternalProject_Add(fribidi
    GIT_REPOSITORY https://github.com/fribidi/fribidi.git
    SOURCE_DIR ${SOURCE_LOCATION}
    GIT_SHALLOW TRUE
    UPDATE_COMMAND ""
    CONFIGURE_COMMAND ${EXEC} meson setup <BINARY_DIR> <SOURCE_DIR>
        --native-file=${MESON_NATIVE}
        -Dcpp_args='-DFRIBIDI_LIB_STATIC'
        -Ddocs=false
        -Dbin=false
        -Dtests=false
    BUILD_COMMAND ${EXEC} ninja
    INSTALL_COMMAND ${EXEC} ninja install
    ${EP_LOG_ARGS}
)

force_meson_configure(fribidi)
cleanup(fribidi install)
