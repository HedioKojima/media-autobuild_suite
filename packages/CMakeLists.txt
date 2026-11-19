set_property(DIRECTORY PROPERTY EP_STEP_TARGETS download)

# curl / openssl / nghttp2 / nghttp3 / ngtcp2 / c-ares / libpsl 的包定义保留在
# packages/ 下（未启用）：这个构建不需要 HTTP(S) 客户端，以后要用时把名字加进
# 下面的列表即可，对应 .cmake 已经是当前架构的写法。
list(APPEND ep
    xz
    uchardet
    zlib
    zstd
    brotli
    lcms2
    libiconv
    nvcodec-headers
    luajit
    fribidi
    freetype2
    harfbuzz
    libunibreak
    libass
    xxhash
    dav1d
    libarchive
    spirv-headers
    spirv-tools
    spirv-cross
    glslang
    vulkan-header
    shaderc
    fast_float
    libplacebo
    ffmpeg
    mpv
)

foreach(package IN LISTS ep)
    if(NOT "${SINGLE_SOURCE_LOCATION}" STREQUAL "")
        set(SOURCE_LOCATION "${SINGLE_SOURCE_LOCATION}/${package}")
    endif()
    include(${CMAKE_CURRENT_SOURCE_DIR}/${package}.cmake)
    set(SOURCE_LOCATION "")
endforeach()

list(LENGTH ep ep_length)
message(STATUS "Parsing ${ep_length} packages")

# 只有下载/清理这类手动目标需要聚合；源码更新由 CI 的 Update sources 步骤完成
# （本地可以 git -C src_packages/<pkg> fetch --depth 1 && git reset --hard FETCH_HEAD）。
list(TRANSFORM ep APPEND "-download" OUTPUT_VARIABLE download)
list(TRANSFORM ep APPEND "-fullclean" OUTPUT_VARIABLE fullclean)

add_custom_target(download
    COMMAND ${CMAKE_COMMAND} --build ${CMAKE_BINARY_DIR} --target ${download}
)

add_custom_target(package-fullclean
    COMMAND ${CMAKE_COMMAND} --build ${CMAKE_BINARY_DIR} --target ${fullclean}
    COMMENT "Remove all stamp files, reset git HEAD"
)
