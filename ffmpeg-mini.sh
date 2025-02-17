#!/bin/sh

set -ex

sudo pacman -S --noconfirm \
  aom \
  glslang \
  gsm \
  jack \
  libass \
  libavc1394 \
  libbluray \
  libbs2b \
  libdvdnav \
  libdvdread \
  libiec61883 \
  libjxl \
  libmodplug \
  libopenmpt \
  libplacebo \
  libraw1394 \
  libsoxr \
  libssh \
  libtheora \
  libva \
  libvdpau \
  libvpx \
  libwebp \
  ocl-icd \
  onevpl \
  opencore-amr \
  rav1e \
  rubberband \
  sdl2 \
  snappy \
  speex \
  srt \
  v4l-utils \
  vapoursynth \
  vid.stab \
  vulkan-icd-loader \
  x264 \
  xvidcore \
  zeromq \
  zimg

ARCH="$(uname -m)"
case "${ARCH}" in
	"x86_64")
		EXT="zst"
		sudo pacman -S --noconfirm svt-av1 vmaf
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
	-e '/--enable-libsvtav1/d' ./PKGBUILD

cat ./PKGBUILD

makepkg -f --skippgpcheck
ls -la
rm -f ./ffmpeg-docs-*.pkg.tar.* ./ffmpeg-debug-*.pkg.tar.*
mv ./ffmpeg-*.pkg.tar.${EXT} ../ffmpeg-x265less-${ARCH}.pkg.tar.${EXT}
cd ..
rm -rf ./ffmpeg
echo "All done!"
