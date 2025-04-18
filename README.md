# llvm-libs-debloated

This repo makes modified versiones of some Archlinux packages, these are intended for AppImages to reduce final size:

* `llvm-libs-mini` and `llmv-libs-nano`, smaller versions of `libLLVM.so` which is a 130+ MiB library that Archlinux compiles with support for a lot of architectures (`arm`, `aarch64`, `risv`, etc), the mini version should be a drop in replacment that is unlikely to cause any issue, while the nano version only ships the host target (`x86_64` or `aarch64`) + `AMDGPU`.

* iculess versions of `libxml2` and `qt6-base`, normally these packages depend on a 30 MiB libicudata lib that is rarely needed, using them gets rid of said library.

* `ffmpeg-mini` which mainly removes linking to libx265.so, which is a 20 MiB library that is rarely needed, using it gets rid of said library.

* `opus-nano` I have no idea why Archlinux makes this lib 5 MiB when both ubuntu and alpine make it <500 KiB

* `mesa-mini` which makes several packages (`mesa`, `vulkan-{radeon, intel, etc}`) ~30% smaller.

# Projects using these packages

* [Anylinux-AppImages](https://github.com/pkgforge-dev/Anylinux-AppImages)

* [ghostty-appimage](https://github.com/psadi/ghostty-appimage)

* [goverlay](https://github.com/benjamimgois/goverlay)

* [interstellar](https://github.com/interstellar-app/interstellar)

* [QDiskInfo](https://github.com/edisionnano/QDiskInfo)
