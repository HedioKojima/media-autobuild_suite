ExternalProject_Add(xz
    GIT_SHALLOW TRUE
    GIT_REPOSITORY https://github.com/tukaani-project/xz.git
    SOURCE_DIR ${SOURCE_LOCATION}
    UPDATE_COMMAND ""
    CONFIGURE_COMMAND ${EXEC} cmake -B <BINARY_DIR> -S <SOURCE_DIR>
        ${EP_CMAKE_ARGS}
        -DBUILD_SHARED_LIBS=OFF
        -DBUILD_TESTING=OFF
        -DXZ_THREADS=yes
        -DXZ_TOOL_XZDEC=OFF
        -DXZ_TOOL_LZMADEC=OFF
        -DXZ_TOOL_LZMAINFO=OFF
        -DXZ_TOOL_XZ=OFF
        -DXZ_DOC=OFF
    BUILD_COMMAND ${EXEC} ninja
    INSTALL_COMMAND ${EXEC} ninja install
    ${EP_LOG_ARGS}
)

cleanup(xz install)
