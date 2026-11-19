# mpv for Windows x64 (MSYS2 clang64, static)

自包含的 mpv 构建仓库：用 CMake ExternalProject 驱动 27 个上游包，在本机
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
| 命令直接执行 `exec` / `reset_head.sh` 等 bash 脚本 | 一律 `bash exec ...`（Windows 没有 shebang 执行） |
| 打完包就 `postremovebuild` 删构建目录、`git restore` | 这些清理只保留成手动 target，不参与构建链 |

## 分支与发布

- 只有 `clang64` 一条流水线（`.github/workflows/build.yml`），默认架构
  `-DGCC_ARCH=x86-64-v3`。
- 只出 Actions artifact（`mpv-x64-clang64-<UTC 时间戳>.7z`）。想要滚动 Release 时
  手动触发并勾 `release`。
- `svtav1`、`subrandr` 不编译。

## 缓存与更新

- MSYS2 侧：`msys2/setup-msys2` 带 `update: true`，每次运行 `pacman -Syu` 到最新，
  安装列表里的工具链（clang/lld/llvm-ar/cmake/ninja/meson…）也都是最新版。
- Git 源码：每次运行都会对 `src_packages` 下所有 git 仓库做一次 `git fetch --depth 1`
  并 reset 到远端（分支跟随分支名，tag 克隆跟随同名 tag）。
- **按变更包定向重建**：只有发生变化的包、以及依赖它的下游（一直推到 mpv）会清掉
  configure/build/install 等 stamp 重新编译，其余包的构建结果原样复用——不再因为
  一个库更新就把整个 `build/` 删掉重来。
- build 缓存 key = 编译器版本 + 构建文件哈希 + **源码指纹**（所有仓库 HEAD 拼起来的
  sha256 前 12 位），所以"缓存命中"和"源码状态"严格对应；源码真变了才会写新的一份缓存。
- 源码缓存只在未命中时保存一份冷启动快照（命中时只做增量 fetch，几十秒），
  避免每次运行都上传 600MB+ 把 build 缓存挤出配额。
- 手动触发时勾 `fullclean` = 清掉所有包的 stamp（含 download），从头完整编译。
- 所有自编库都装在 `build/prefix` 下（不再装进 MSYS2 的 clang64 根目录）：runner 每次
  都是全新的，系统前缀留不住，装在那里等于每次都丢，恢复回来的 build 树会因为找不到
  `.pc`/头文件而 configure 失败。放进 `build` 里就能跟着构建缓存一起走。
- 例外：`libiconv` 用固定 `URL_HASH` 的发行包，不跟上游走（源码包本来就没有「新版本」概念）。

## 构建

本地（MSYS2 CLANG64 shell）：

```bash
cmake -G Ninja -B build -S . \
  -DMINGW_INSTALL_PREFIX="$(cygpath -m "$MINGW_PREFIX")" \
  -DSINGLE_SOURCE_LOCATION="$(cygpath -m "$PWD/src_packages")" \
  -DGCC_ARCH=x86-64-v3
ninja -C build download
ninja -C build mpv
```

产物在 `build/mpv/mpv.exe`。`-DGCC_ARCH=znver3` 可以按固定 CPU 优化（参考仓库默认 znver3，
这里默认 `x86-64-v3` 以保证在别的机器上也能跑）。

CI：`.github/workflows/build.yml`，push 到 `clang64` 或手动触发（workflow_dispatch）才会构建；
手动触发可勾 `release` 发布滚动 release，勾 `fullclean` 全量重编。

## 目录

```
CMakeLists.txt             顶层：目标三元组、安装前缀、ccache、生成 toolchain/meson native 文件
toolchain.cmake.in         原生 clang64 工具链（clang/clang++、llvm-windres、-O3 -march、-static）
meson_native.ini.in        meson 原生文件（static、prefer_static、ccache、c_args/c_link_args）
exec.in                    每个包的执行包装：PATH、PKG_CONFIG_LIBDIR、AR/NM/RANLIB/STRIP、CC/CXX
cmake/custom_steps.cmake   cleanup / force_meson_configure 等 ExternalProject 扩展
（不再引入第三方补丁：直接用 CMake 自带 ExternalProject + 标准 GIT_SHALLOW）
packages/CMakeLists.txt    包清单与 download/fullclean 聚合目标
packages/*.cmake           每个包一个定义（git 源、configure、build、install；公共 cmake 参数用 ${EP_CMAKE_ARGS}）
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
