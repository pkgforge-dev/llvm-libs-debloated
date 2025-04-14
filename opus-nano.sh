#!/bin/sh

set -ex

ARCH="$(uname -m)"

sudo pacman -S --noconfirm doxygen meson

git clone https://gitlab.archlinux.org/archlinux/packaging/packages/opus.git ./opus
cd ./opus

sed -i -e "s/x86_64/${ARCH}/" ./PKGBUILD

# remove features that make the lib 5 MiB
sed -i -e '/-D deep-plc=enabled/d' \
	-e '/-D dred=enabled/d' \
	-e '/-D osce=enabled/d' ./PKGBUILD

case "${ARCH}" in
	"x86_64")
		EXT="zst"
		;;
	"aarch64")
		EXT="xz"
		;;
	*)
		echo "Unsupported Arch: '${ARCH}'"
		exit 1
		;;
esac

cat ./PKGBUILD

makepkg -f --skippgpcheck
ls -la
rm -fv *-docs-*.pkg.tar.* *-debug-*.pkg.tar.*
mv ./opus-*.pkg.tar.${EXT} ../opus-nano-${ARCH}.pkg.tar.${EXT}
cd ..
rm -rf ./opus
echo "All done!"
