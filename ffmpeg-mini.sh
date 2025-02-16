#!/bin/sh

set -ex

ARCH="$(uname -m)"
case "${ARCH}" in
	"x86_64")
		EXT="zst"
		git clone https://gitlab.archlinux.org/archlinux/packaging/packages/ffmpeg.git ffmpeg
		cd ./ffmpeg
		;;
	"aarch64")
		EXT="xz"
		git clone https://raw.githubusercontent.com/archlinuxarm/PKGBUILDs/refs/heads/master/extra/ffmpeg/PKGBUILD ffmpeg
		cd ./ffmpeg
		sed -i "s/x86_64/${ARCH}/" ./PKGBUILD
		;;
	*)
		echo "Unsupported Arch: '${ARCH}'"
		exit 1
		;;
esac

# remove x265 support and AV1 encoding support
sed -i -e '/x265/d' \
	-e '/librav1e/d' \
	-e '/--enable-libsvtav1/d' ./PKGBUILD

cat ./PKGBUILD

makepkg -f --skippgpcheck
ls -la
rm -f ./ffmpeg-docs-*.pkg.tar.* ./ffmpeg-debug-*-x86_64.pkg.tar.*
mv ./ffmpeg-*.pkg.tar.${EXT} ../ffmpeg-x265less-${ARCH}.pkg.tar.${EXT}
cd ..
rm -rf ./ffmpeg
echo "All done!"
