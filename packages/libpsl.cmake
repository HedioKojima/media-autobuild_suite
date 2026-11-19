ExternalProject_ADD(libpsl
    GIT_REPOSITORY https://github.com/rockdaboot/libpsl.git
    SOURCE_DIR ${SOURCE_LOCATION}
    GIT_SHALLOW TRUE
    UPDATE_COMMAND ""
    CONFIGURE_COMMAND ""
    COMMAND ${EXEC} echo > <SOURCE_DIR>/tools/meson.build
    COMMAND ${EXEC} meson setup <BINARY_DIR> <SOURCE_DIR>
        --native-file=${MESON_NATIVE}
        -Druntime=no
        -Dtests=false
    BUILD_COMMAND ${EXEC} ninja src/suffixes_dafsa.h
    INSTALL_COMMAND ${EXEC} ninja install
    ${EP_LOG_ARGS}
)

force_meson_configure(libpsl)
cleanup(libpsl install)
