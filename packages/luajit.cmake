set(LUAJIT_MAKE_ARGS
    TARGET_SYS=Windows
    BUILDMODE=static
    FILE_T=luajit.exe
    CFLAGS=-DUNICODE
    XCFLAGS=-march=${GCC_ARCH}
    PREFIX=${MINGW_INSTALL_PREFIX}
)

ExternalProject_Add(luajit
    GIT_REPOSITORY https://github.com/LuaJIT/LuaJIT.git
    SOURCE_DIR ${SOURCE_LOCATION}
    GIT_REMOTE_NAME origin
    GIT_TAG v2.1
    UPDATE_COMMAND ""
    CONFIGURE_COMMAND ""
    BUILD_COMMAND ${MAKE} -C <SOURCE_DIR>/src ${LUAJIT_MAKE_ARGS} amalg
    INSTALL_COMMAND ${MAKE} ${LUAJIT_MAKE_ARGS} install
            COMMAND ${EXEC} "sed -i 's|^Libs.private:.*|Libs.private: -lm|' ${MINGW_INSTALL_PREFIX}/lib/pkgconfig/luajit.pc"
    BUILD_IN_SOURCE 1
    ${EP_LOG_ARGS}
)

cleanup(luajit install)
