# llvm-libs-debloated

This repo makes modified versiones of some Archlinux packages, these are intended for AppImages to reduce final size:

* `llvm-libs-mini` and `llmv-libs-nano`, smaller versions of `libLLVM.so` which is a 130+ MiB library that Archlinux compiles with support for a lot of arquitectures (arm, aarch64, risv, etc), the mini version should be a drop in replacment that is unlikely to cause any issue, while the nano version depends but usually is fine as well.

* iculess versions of `libxml2` and `qt6-base`, normally these packages depend on a 30 MiB libicudata lib that is rarely needed, using them gets rid of said library.
