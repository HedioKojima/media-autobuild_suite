ExternalProject_Add(spirv-cross
    GIT_SHALLOW TRUE
    GIT_REPOSITORY https://github.com/KhronosGroup/SPIRV-Cross.git
    SOURCE_DIR ${SOURCE_LOCATION}
    GIT_REMOTE_NAME origin
    GIT_TAG main
    UPDATE_COMMAND ""
    CONFIGURE_COMMAND ${EXEC} cmake -B <BINARY_DIR> -S <SOURCE_DIR>
        ${EP_CMAKE_ARGS}
        -DBUILD_SHARED_LIBS=OFF
        -DSPIRV_CROSS_SHARED=OFF
        -DSPIRV_CROSS_CLI=OFF
        -DSPIRV_CROSS_ENABLE_TESTS=OFF
        -DSPIRV_CROSS_ENABLE_MSL=OFF
        -DSPIRV_CROSS_ENABLE_CPP=OFF
        -DSPIRV_CROSS_ENABLE_REFLECT=OFF
        -DSPIRV_CROSS_ENABLE_UTIL=OFF
        -DSPIRV_CROSS_EXCEPTIONS_TO_ASSERTIONS=ON
    BUILD_COMMAND ${EXEC} ninja
          COMMAND ${EXEC} llvm-lib /out:libspirv-cross-c.a libspirv-cross-{c,core,glsl,hlsl}.a
    INSTALL_COMMAND ${EXEC} ninja install
            COMMAND ${CMAKE_COMMAND} -E copy ${MINGW_INSTALL_PREFIX}/lib/pkgconfig/spirv-cross-c.pc
                                                       ${MINGW_INSTALL_PREFIX}/lib/pkgconfig/spirv-cross-c-shared.pc
    ${EP_LOG_ARGS}
)

cleanup(spirv-cross install)
