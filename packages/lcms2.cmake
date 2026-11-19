ExternalProject_Add(lcms2
    GIT_SHALLOW TRUE
    GIT_REPOSITORY https://github.com/mm2/Little-CMS.git
    SOURCE_DIR ${SOURCE_LOCATION}
    UPDATE_COMMAND ""
    CONFIGURE_COMMAND ${EXEC} meson setup <BINARY_DIR> <SOURCE_DIR>
        --native-file=${MESON_NATIVE}
        -Dtests=disabled
        -Djpeg=disabled
    BUILD_COMMAND ${EXEC} ninja
    INSTALL_COMMAND ${EXEC} ninja install
    ${EP_LOG_ARGS}
)

force_meson_configure(lcms2)
cleanup(lcms2 install)
