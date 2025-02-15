#!/bin/sh

set -ex

ARCH="$(uname -m)"

git clone https://gitlab.archlinux.org/archlinux/packaging/packages/qt6-base qt6-base
cd ./qt6-base

# remove the line that enables icu support
sed -i -e "s/x86_64/${ARCH}/" \
	-e 's/-DFEATURE_journald=ON/-DFEATURE_journald=OFF/' \
	-e '/-DFEATURE_libproxy=ON \\/a\    -DFEATURE_icu=OFF \\' ./PKGBUILD

case "${ARCH}" in
	"x86_64")
		EXT="zst"
		;;
	"aarch64")
		EXT="xz"
		sed -i 's/-DFEATURE_no_direct_extern_access=ON/-DQT_FEATURE_sql_ibase=OFF/' ./PKGBUILD
		;;
	*)
		echo "Unsupported Arch: '${ARCH}'"
		exit 1
		;;
esac

cat ./PKGBUILD

makepkg -f --skippgpcheck
ls -la
rm -fv qt6-base-docs-*.pkg.tar.* qt6-base-debug-*.pkg.tar.*
mv ./qt6-base-*.pkg.tar.${EXT} ../qt6-base-iculess-${ARCH}.pkg.tar.${EXT}
cd ..
rm -rf ./qt6-base
echo "All done!"
