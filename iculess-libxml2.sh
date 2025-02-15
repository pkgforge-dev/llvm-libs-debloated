#!/bin/sh

set -e

ARCH="$(uname -m)"

case "${ARCH}" in
	"x86_64")
		TARGETS_TO_BUILD="X86;AMDGPU"
		EXT="zst"
		;;
	"aarch64")
		TARGETS_TO_BUILD="AArch64;AMDGPU"
		EXT="xz"
		;;
	*)
		echo "Unsupported Arch: '${ARCH}'"
		exit 1
		;;
esac

git clone https://gitlab.archlinux.org/archlinux/packaging/packages/libxml2.git libxml2
cd ./libxml2

# remove the line that enables icu support
sed -i '/--with-icu/d' ./PKGBUILD
cat ./PKGBUILD

makepkg -f --skippgpcheck
ls -la
rm -f libxml2-docs-*.pkg.tar.*
mv ./libxml2-*.pkg.tar.${EXT} ../libxml2-iculess-${ARCH}.pkg.tar.${EXT}
cd ..
rm -rf ./libxml2
echo "All done!"
