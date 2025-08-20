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
		git clone --depth 1 https://github.com/archlinuxarm/PKGBUILDs.git PKGBUILDs
		mv ./PKGBUILDs/extra/ffmpeg ./
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
	-e 's/--enable-libsvtav1/--enable-small/' \
	-e '/--enable-vapoursynth/d' ./PKGBUILD

cat ./PKGBUILD

makepkg -fs --noconfirm --skippgpcheck
ls -la
rm -f ./ffmpeg-docs-*.pkg.tar.* ./ffmpeg-debug-*.pkg.tar.*
mv ./ffmpeg-*.pkg.tar.${EXT} ../ffmpeg-mini-${ARCH}.pkg.tar.${EXT}
cd ..
rm -rf ./ffmpeg
echo "All done!"
