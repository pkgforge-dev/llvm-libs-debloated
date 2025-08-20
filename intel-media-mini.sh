#!/bin/sh

set -ex

ARCH="$(uname -m)"

git clone https://gitlab.archlinux.org/archlinux/packaging/packages/intel-media-driver.git ./intel-media-driver
cd ./intel-media-driver

# Build with MinSizeRel for smaller lib
sed -i -e 's|-DINSTALL_DRIVER_SYSCONF=OFF|-DINSTALL_DRIVER_SYSCONF=OFF -DBUILD_TYPE=MinSizeRel -DENABLE_NONFREE_KERNELS=OFF|' ./PKGBUILD

case "${ARCH}" in
	"x86_64")
		EXT="zst"
		;;
	*)
		echo "Unsupported Arch: '${ARCH}'"
		exit 1
		;;
esac

cat ./PKGBUILD

makepkg -fs --noconfirm --skippgpcheck
ls -la
rm -fv *-docs-*.pkg.tar.* *-debug-*.pkg.tar.*
mv ./intel-*.pkg.tar.${EXT} ../intel-media-mini-${ARCH}.pkg.tar.${EXT}
cd ..
rm -rf ./intel-media-driver
echo "All done!"
