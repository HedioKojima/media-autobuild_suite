ExternalProject_Add(uchardet
    GIT_SHALLOW TRUE
    GIT_REPOSITORY https://gitlab.freedesktop.org/uchardet/uchardet.git
    SOURCE_DIR ${SOURCE_LOCATION}
    UPDATE_COMMAND ""
    CONFIGURE_COMMAND ${EXEC} cmake -B <BINARY_DIR> -S <SOURCE_DIR>
        ${EP_CMAKE_ARGS}
        -DBUILD_SHARED_LIBS=OFF
        -DBUILD_STATIC=ON
        -DBUILD_BINARY=OFF
        -DTARGET_ARCHITECTURE=${TARGET_CPU_FAMILY}
        -DCMAKE_POLICY_VERSION_MINIMUM=3.5
    BUILD_COMMAND ${EXEC} ninja
    INSTALL_COMMAND ${EXEC} ninja install
            COMMAND ${EXEC} sed -i 's/stdc++/c++/g' ${MINGW_INSTALL_PREFIX}/lib/pkgconfig/uchardet.pc
    ${EP_LOG_ARGS}
)

cleanup(uchardet install)
