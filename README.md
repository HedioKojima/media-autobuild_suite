# mpv for Windows x64 (MSYS2 clang64, static)

自包含的 mpv 构建仓库：用 CMake ExternalProject 驱动 28 个上游包，在本机
**MSYS2 clang64** 环境里原生编译，产出单个静态 `mpv.exe`（无 DLL 依赖）。

结构参考 [HedioKojima/mpv-win](https://github.com/HedioKojima/mpv-win)
（其自身修改自 [Kosm8/mpv-winbuild](https://github.com/Kosm8/mpv-winbuild/tree/rm)，
MIT，见 `LICENSE`），差别在于**工具链层整体换掉**：

| 参考仓库（mpv-win） | 本仓库 |
|---|---|
| Linux 上交叉编译到 `x86_64-w64-mingw32` | Windows 上原生编译 |
| 下载 llvm-mingw（Kosm8）当工具链 | 直接用 MSYS2 `clang64` 的 clang / lld / llvm-ar |
| `llvm-compiler.in`、`llvm-ld.in`、`llvm-mingw-wrapper.cmake` 注入 `-target`/`--sysroot`/ThinLTO | 全部删除，编译器参数直接写进 `toolchain.cmake.in` |
| `meson_cross.txt.in` 交叉文件 | `meson_native.ini.in` 原生文件 |
| Rust 交叉编译 `x86_64-pc-windows-gnullvm`（供 subrandr） | 不编译 Rust 依赖，`subrandr` 暂不提供 |
| `create_symlink` 拼 third_party 目录 | `copy_directory`（Windows 无 symlink 权限保证） |

## 构建

本地（MSYS2 CLANG64 shell）：

```bash
cmake -G Ninja -B build -S . \
  -DMINGW_INSTALL_PREFIX="$(cygpath -m "$MINGW_PREFIX")" \
  -DSINGLE_SOURCE_LOCATION="$(cygpath -m "$PWD/src_packages")" \
  -DGCC_ARCH=x86-64-v3
ninja -C build download
ninja -C build update
ninja -C build mpv
```

产物在 `build/mpv/mpv.exe`。`-DGCC_ARCH=znver3` 可以按固定 CPU 优化（参考仓库默认 znver3，
这里默认 `x86-64-v3` 以保证在别的机器上也能跑）。

CI：`.github/workflows/build.yml`，push 到 `deploy`/`clang64`、PR、手动触发都会构建；
手动触发可勾 `release` 发布滚动 release，勾 `fullclean` 全量重编。

## 目录

```
CMakeLists.txt             顶层：目标三元组、安装前缀、ccache、生成 toolchain/meson native 文件
toolchain.cmake.in         原生 clang64 工具链（clang/clang++、llvm-windres、-O3 -march、-static）
meson_native.ini.in        meson 原生文件（static、prefer_static、ccache、c_args/c_link_args）
exec.in                    每个包的执行包装：PATH、PKG_CONFIG_LIBDIR、AR/NM/RANLIB/STRIP、CC/CXX
cmake/custom_steps.cmake   cleanup / force_rebuild_git / force_meson_configure 等 ExternalProject 扩展
cmake/download_externalproject.cmake  拉取并 patch 过的 ExternalProject.cmake（带 _EP_* 属性）
packages/CMakeLists.txt    包清单与 update/download/fullclean 聚合目标
packages/*.cmake           每个包一个定义（git 源、configure、build、install）
```

## 依赖与取舍

包集合与参考仓库一致：`xz zlib zstd brotli lcms2 libiconv nvcodec-headers luajit fribidi
freetype2 harfbuzz libunibreak libass xxhash dav1d libarchive spirv-headers spirv-tools
spirv-cross glslang vulkan-header shaderc fast_float libplacebo ffmpeg mpv`。

- FFmpeg 沿用参考仓库的极简配置：只留原生解码器、`d3d11va`+`nvdec` 硬解、`libdav1d`，
  关掉 doc/programs/大部分编码器。mkv/mp4 由 mpv 自己的 demuxer 处理，不依赖 FFmpeg 的 matroska demuxer。
- mpv 侧 `-Dgl=disabled -Ddirect3d=disabled`，libplacebo 侧 `-Dopengl=disabled -Dvulkan=disabled`：
  视频输出走 D3D11（`--vo=gpu`/`gpu-next`），与参考仓库一致；想要 Vulkan/OpenGL 后端需要同时改这两处。
- 未编译 `svtav1`：它在 CI 里 `git clone` 直接失败并让整条下载链中断，AV1 解码仍由 dav1d 负责；
  要恢复就把 `packages/svtav1.cmake` 加回清单并恢复 ffmpeg 的 `--enable-libsvtav1`/`--enable-encoder=libsvtav1`。
- 未包含 `subrandr`（Rust 实现，SRV3/WebVTT 字幕渲染后端），因为需要额外引入 rustup +
  `x86_64-pc-windows-gnullvm` 目标；需要时把 `packages/subrandr.cmake` 加回来并恢复 Rust 步骤。
