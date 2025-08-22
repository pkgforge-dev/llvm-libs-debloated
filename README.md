# archlinux-pkgs-debloated 

*Previously known as 'llvm-libs-debloated'*

---

This repo makes modified versiones of some Archlinux packages, these are intended for AppImages to reduce final size:

* `mesa-mini` and `vulkan-{radeon,intel,etc}-mini` **Mesa that does not link to `libLLVM.so`**, making any hardware accelerated app tiny as result.

* `mesa-nano` and `vulkan-{radeon,intel,etc}-nano` similar to `mesa-mini`, built with -Oz which makes it ~30% smaller, note -Os can have a performance and even stability issue so do not use this package in apps like emulators where this is critical.

* `llvm-libs-mini` and `llmv-libs-nano`, smaller versions of `libLLVM.so` which is a 130+ MiB library that Archlinux compiles with support for a lot of architectures (`arm`, `aarch64`, `risv`, etc), the mini version should be a drop in replacment that is unlikely to cause any issue, while the nano version only ships the host target (`x86_64` or `aarch64`) + `AMDGPU`.

* iculess versions of `libxml2` and `qt6-base`, normally these packages depend on a 30 MiB libicudata lib that is rarely needed, using them gets rid of said library.

* `ffmpeg-mini` which mainly removes linking to libx265.so, which is a 20 MiB library that is rarely needed, using it gets rid of said library.

* `opus-nano` I have no idea why Archlinux makes this lib 5 MiB when both ubuntu and alpine make it <500 KiB

# Projects using these packages

* [Anylinux-AppImages](https://github.com/pkgforge-dev/Anylinux-AppImages)

* [ghostty-appimage](https://github.com/psadi/ghostty-appimage)

* [goverlay](https://github.com/benjamimgois/goverlay)

* [Steam-appimage](https://github.com/ivan-hc/Steam-appimage)

* [interstellar](https://github.com/interstellar-app/interstellar)

* [QDiskInfo](https://github.com/edisionnano/QDiskInfo)

* [mangojuice](https://github.com/radiolamp/mangojuice)

* [CPU-X](https://github.com/TheTumultuousUnicornOfDarkness/CPU-X)

* [ppsspp](https://github.com/hrydgard/ppsspp)

* [Eden](https://github.com/eden-emulator/Releases)
