ExternalProject_Add(ffmpeg
    DEPENDS
        zlib
        libiconv
        dav1d
        nvcodec-headers
        #curl
    GIT_REPOSITORY https://github.com/FFmpeg/FFmpeg.git
    SOURCE_DIR ${SOURCE_LOCATION}
    GIT_SHALLOW TRUE
    UPDATE_COMMAND ""
    CONFIGURE_COMMAND ${EXEC} <SOURCE_DIR>/configure
        --prefix=${MINGW_INSTALL_PREFIX}
        --arch=${TARGET_CPU}
        --cc=clang
        --cxx=clang++
        --target-os=mingw32
        --pkg-config=pkgconf
        --pkg-config-flags=--static
        --enable-lto=thin
        --enable-static
        --disable-shared
        --enable-runtime-cpudetect
        --disable-autodetect
        --enable-zlib
        --enable-iconv
        --enable-libdav1d
        --enable-schannel
        --enable-d3d11va
        --enable-ffnvcodec
        --disable-cuvid
        --enable-nvdec
        --disable-nvenc
        --disable-doc
        --disable-programs
        --disable-debug
        --disable-avdevice
        --disable-demuxer=matroska
        --disable-devices
        --disable-encoders
        --enable-encoder=png
        --enable-encoder=mjpeg
        --disable-decoder=aac_fixed,ac3_fixed,mp1,mp2,mp3,mp3adu,mp3on4
        --enable-w32threads
    BUILD_COMMAND ${MAKE}
    INSTALL_COMMAND ${MAKE} install
    ${EP_LOG_ARGS}
)

cleanup(ffmpeg install)
