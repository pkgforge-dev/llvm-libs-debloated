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

git clone https://gitlab.archlinux.org/archlinux/packaging/packages/qt6-base qt6-base
cd ./qt6-base

# remove the line that enables icu support
sed -i -e 's/-DFEATURE_journald=ON/-DFEATURE_journald=OFF/' \
	-e '/-DFEATURE_libproxy=ON \\/a\    -DFEATURE_icu=OFF \\' ./PKGBUILD
cat ./PKGBUILD

makepkg -f --skippgpcheck
ls -la
rm -f qt6-base-docs-*.pkg.tar.*
mv ./qt6-base-*.pkg.tar.${EXT} ../qt6-base-iculess-${ARCH}.pkg.tar.${EXT}
cd ..
rm -rf ./qt6-base
echo "All done!"
