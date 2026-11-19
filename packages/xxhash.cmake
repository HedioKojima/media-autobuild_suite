ExternalProject_Add(xxhash
    GIT_SHALLOW TRUE
    GIT_REPOSITORY https://github.com/Cyan4973/xxHash.git
    SOURCE_DIR ${SOURCE_LOCATION}
    GIT_TAG dev
    UPDATE_COMMAND ""
    GIT_REMOTE_NAME origin
    CONFIGURE_COMMAND ${EXEC} cmake -B <BINARY_DIR> -S <SOURCE_DIR>/build/cmake
        ${EP_CMAKE_ARGS}
        -DBUILD_SHARED_LIBS=OFF
        -DXXHASH_BUILD_XXHSUM=OFF
        -DDISPATCH=ON
    BUILD_COMMAND ${EXEC} ninja
    INSTALL_COMMAND ${EXEC} ninja install
    ${EP_LOG_ARGS}
)

cleanup(xxhash install)
