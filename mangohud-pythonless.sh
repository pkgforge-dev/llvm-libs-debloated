#!/bin/sh

set -ex

ARCH="$(uname -m)"

pacman -S --noconfirm \
	appstream \
	cmocka \
	glew \
	glfw \
	glslang \
	hicolor-icon-theme \
	libxkbcommon \
	libxrandr \
	meson \
	nlohmann-json \
	python-mako \
	vulkan-headers

git clone https://github.com/VHSgunzo/mangohud-PKGBUILD.git ./mangohud-temp
mv -v ./mangohud-temp/mangohud ./
rm -rf ./mangohud-temp

cd ./mangohud

sed -i -e "s|x86_64|$(uname -m)|" ./PKGBUILD

case "${ARCH}" in
	"x86_64")
		EXT="zst"
		pacman -S --noconfirm libxnvctrl
		;;
	"aarch64")
		EXT="xz"

		# remove libxnvctrl since it is not possible in aarch64
		sed -i -e "s|x86_64|$(uname -m)|" \
			-e 's|-Dmangohudctl=true|-Dmangohudctl=true -Dwith_xnvctrl=disabled|' \
			-e '/libxnvctrl/d' ./PKGBUILD
		;;
	*)
		echo "Unsupported Arch: '${ARCH}'"
		exit 1
		;;
esac

cat ./PKGBUILD

makepkg -f --skippgpcheck
ls -la
rm -fv mangohud-docs-*.pkg.tar.* mangohud-debug-*.pkg.tar.*
mv ./mangohud-*.pkg.tar.${EXT} ../mangohud-iculess-${ARCH}.pkg.tar.${EXT}
cd ..
rm -rf ./mangohud
echo "All done!"
