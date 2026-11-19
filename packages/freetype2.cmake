ExternalProject_Add(freetype2
    GIT_SHALLOW TRUE
    GIT_REPOSITORY https://github.com/freetype/freetype.git
    SOURCE_DIR ${SOURCE_LOCATION}
    GIT_SUBMODULES ""
    UPDATE_COMMAND ""
    CONFIGURE_COMMAND ${EXEC} meson setup <BINARY_DIR> <SOURCE_DIR>
        --native-file=${MESON_NATIVE}
        -Dharfbuzz=disabled
        -Dtests=disabled
        -Dpng=disabled
        -Dbrotli=disabled
        -Dzlib=disabled
    BUILD_COMMAND ${EXEC} ninja
    INSTALL_COMMAND ${EXEC} ninja install
    ${EP_LOG_ARGS}
)

force_meson_configure(freetype2)
cleanup(freetype2 install)
