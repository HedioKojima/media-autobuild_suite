ExternalProject_Add(zlib
    GIT_REPOSITORY https://github.com/zlib-ng/zlib-ng.git
    SOURCE_DIR ${SOURCE_LOCATION}
    GIT_SHALLOW TRUE
    UPDATE_COMMAND ""
    GIT_REMOTE_NAME origin
    GIT_TAG develop
    CONFIGURE_COMMAND ${EXEC} cmake -B <BINARY_DIR> -S <SOURCE_DIR>
        ${EP_CMAKE_ARGS}
        -DINSTALL_PKGCONFIG_DIR=${MINGW_INSTALL_PREFIX}/lib/pkgconfig
        -DBUILD_SHARED_LIBS=OFF
        -DBUILD_TESTING=OFF
        -DSKIP_INSTALL_LIBRARIES=OFF
        -DZLIB_COMPAT=ON
    BUILD_COMMAND ${EXEC} ninja
    INSTALL_COMMAND ${EXEC} ninja install
    ${EP_LOG_ARGS}
)

cleanup(zlib install)
