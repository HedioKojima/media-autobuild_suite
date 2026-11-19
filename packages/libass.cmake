ExternalProject_Add(libass
    DEPENDS
        harfbuzz
        freetype2
        fribidi
        libiconv
        libunibreak
    GIT_SHALLOW TRUE
    GIT_REPOSITORY https://github.com/libass/libass.git
    SOURCE_DIR ${SOURCE_LOCATION}
    UPDATE_COMMAND ""
    CONFIGURE_COMMAND ${EXEC} meson setup <BINARY_DIR> <SOURCE_DIR>
        --buildtype=release
        --native-file=${MESON_NATIVE}
        -Dfontconfig=disabled
        -Ddirectwrite=enabled
        -Dasm=enabled
        -Dlibunibreak=enabled
        -Dtest=disabled
        -Dcompare=disabled
        -Dprofile=disabled
        -Dfuzz=disabled
        -Dcheckasm=disabled
    BUILD_COMMAND ${EXEC} ninja
    INSTALL_COMMAND ${EXEC} ninja install
    ${EP_LOG_ARGS}
)

force_meson_configure(libass)
cleanup(libass install)
