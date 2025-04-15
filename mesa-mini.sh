#!/bin/sh

set -ex

ARCH="$(uname -m)"

pacman -S --noconfirm \
	clang \
	directx-headers \
	expat \
	gcc-libs \
	glibc \
	libdrm \
	libelf \
	libglvnd \
	libpng \
	libva \
	libvdpau \
	libx11 \
	libxcb \
	libxext \
	libxml2 \
	libxrandr \
	libxshmfence \
	libxxf86vm \
	llvm \
	llvm-libs \
	lm_sensors \
	rust \
	spirv-llvm-translator \
	spirv-tools \
	systemd-libs \
	vulkan-icd-loader \
	wayland \
	xcb-util-keysyms \
	cbindgen \
	clang \
	cmake \
	elfutils \
	glslang \
	libclc \
	meson \
	python-mako \
	python-packaging \
	python-ply \
	python-yaml \
	rust-bindgen \
	wayland-protocols \
	xorgproto \
	valgrind \
	python-sphinx \
	python-sphinx-hawkmoth

case "${ARCH}" in
	"x86_64")
		EXT="zst"
		git clone https://gitlab.archlinux.org/archlinux/packaging/packages/mesa.git ./mesa
		cd ./mesa
		;;
	"aarch64")
		EXT="xz"
		pacman -S --noconfirm python-pycparser
		git clone https://github.com/archlinuxarm/PKGBUILDs ./mesa
		cd ./mesa
		mv -v ./extra/mesa/* ./extra/mesa/.* ./
		;;
	*)
		echo "Unsupported Arch: '${ARCH}'"
		exit 1
		;;
esac

sed -i -e "s/x86_64/${ARCH}/" ./PKGBUILD

# debloat mesa
sed -i -e 's/r300,//' \
	-e 's/svga,//' \
	-e 's/softpipe,//' \
	-e 's/gallium-nine=true/gallium-nine=false/' \
	-e 's/-g1/-g0 -Os/g' ./PKGBUILD

cat ./PKGBUILD

makepkg -f --skippgpcheck
ls -la
rm -fv *-docs-*.pkg.tar.* *-debug-*.pkg.tar.*
mv -v ./mesa-*.pkg.tar.${EXT}           ../mesa-mini-${ARCH}.pkg.tar.${EXT}
mv -v ./vulkan-radeon-*.pkg.tar.${EXT}  ../vulkan-radeon-mini-${ARCH}.pkg.tar.${EXT}
mv -v ./vulkan-nouveau-*.pkg.tar.${EXT} ../vulkan-nouveau-mini-${ARCH}.pkg.tar.${EXT}

if [ "$ARCH" = 'x86_64' ]; then
	mv -v ./vulkan-intel-*.pkg.tar.${EXT} ../vulkan-intel-mini-${ARCH}.pkg.tar.${EXT}
else
	mv -v ./vulkan-broadcom-*.pkg.tar.${EXT}  ../vulkan-broadcom-mini-${ARCH}.pkg.tar.${EXT}
	mv -v ./vulkan-panfrost-*.pkg.tar.${EXT}  ../vulkan-panfrost-mini-${ARCH}.pkg.tar.${EXT}
	mv -v ./vulkan-freedreno-*.pkg.tar.${EXT} ../vulkan-freedreno-mini-${ARCH}.pkg.tar.${EXT}
fi
cd ..
rm -rf ./mesa
echo "All done!"
