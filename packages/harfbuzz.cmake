ExternalProject_Add(harfbuzz
    DEPENDS
        freetype2
    GIT_REPOSITORY https://github.com/harfbuzz/harfbuzz.git
    SOURCE_DIR ${SOURCE_LOCATION}
    GIT_REMOTE_NAME origin
    GIT_TAG main
    GIT_SHALLOW TRUE
    UPDATE_COMMAND ""
    CONFIGURE_COMMAND ${EXEC} meson setup <BINARY_DIR> <SOURCE_DIR>
        --buildtype=release
        --native-file=${MESON_NATIVE}
        -Dicu=disabled
        -Dglib=disabled
        -Dgobject=disabled
        -Dtests=disabled
        -Ddocs=disabled
        -Dutilities=disabled
    BUILD_COMMAND ${EXEC} ninja
    INSTALL_COMMAND ${EXEC} ninja install
    ${EP_LOG_ARGS}
)

force_meson_configure(harfbuzz)
cleanup(harfbuzz install)
