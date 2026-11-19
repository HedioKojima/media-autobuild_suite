ExternalProject_Add(zstd
    GIT_REPOSITORY https://github.com/facebook/zstd.git
    SOURCE_DIR ${SOURCE_LOCATION}
    GIT_SHALLOW TRUE
    UPDATE_COMMAND ""
    GIT_REMOTE_NAME origin
    GIT_TAG dev
    CONFIGURE_COMMAND ${EXEC} meson setup <BINARY_DIR> <SOURCE_DIR>/build/meson
        --native-file=${MESON_NATIVE}
        -Dbin_contrib=false
        -Dbin_programs=false
        -Dbin_tests=false
        -Ddebug_level=0
        -Dlegacy_level=0
        -Dlz4=disabled
        -Dlzma=disabled
        -Dzlib=disabled
    BUILD_COMMAND ${EXEC} ninja
    INSTALL_COMMAND ${EXEC} ninja install
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

force_meson_configure(zstd)
cleanup(zstd install)
