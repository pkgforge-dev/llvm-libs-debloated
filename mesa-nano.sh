#!/bin/sh

set -ex

ARCH="$(uname -m)"

sed -i -e 's|-O2|-Oz|' /etc/makepkg.conf

case "${ARCH}" in
	"x86_64")
		EXT="zst"
		git clone https://gitlab.archlinux.org/archlinux/packaging/packages/mesa.git ./mesa
		cd ./mesa
		;;
	"aarch64")
		EXT="xz"
		git clone https://github.com/archlinuxarm/PKGBUILDs ./mesa
		cd ./mesa
		mv -v ./extra/mesa/* ./extra/mesa/.* ./

		# FIX THIS WHOLE MESS
		sed -i 's|https://mesa.freedesktop.org/archive/mesa|https://archive.mesa3d.org/mesa|' ./PKGBUILD
		;;
	*)
		echo "Unsupported Arch: '${ARCH}'"
		exit 1
		;;
esac

sed -i -e "s/x86_64/${ARCH}/" ./PKGBUILD

# debloat mesa
sed -i \
	-e '/llvm-libs/d'      \
	-e 's/vulkan-swrast//' \
	-e 's/opencl-mesa//'   \
	-e 's/r300,//'         \
	-e 's/r600,//'         \
	-e 's/svga,//'         \
	-e 's/softpipe,//'     \
	-e 's/llvmpipe,//'     \
	-e 's/swrast,//'       \
	-e '/sysprof/d'        \
	-e '/_pick vkswrast/d' \
	-e '/_pick opencl/d'   \
	-e 's/intel-rt=enabled/intel-rt=disabled/'         \
	-e 's/gallium-rusticl=true/gallium-rusticl=false/' \
	-e 's/valgrind=enabled/valgrind=disabled/'         \
	-e 's/-D video-codecs=all/-D video-codecs=all -D amd-use-llvm=false -D draw-use-llvm=false/' \
	-e 's/-g1/-g0 -Oz/g' ./PKGBUILD

cat ./PKGBUILD

makepkg -fs --noconfirm --skippgpcheck
ls -la
rm -fv *-docs-*.pkg.tar.* *-debug-*.pkg.tar.*
mv -v ./mesa-*.pkg.tar.${EXT}           ../mesa-nano-${ARCH}.pkg.tar.${EXT}
mv -v ./vulkan-radeon-*.pkg.tar.${EXT}  ../vulkan-radeon-nano-${ARCH}.pkg.tar.${EXT}
mv -v ./vulkan-nouveau-*.pkg.tar.${EXT} ../vulkan-nouveau-nano-${ARCH}.pkg.tar.${EXT}

if [ "$ARCH" = 'x86_64' ]; then
	mv -v ./vulkan-intel-*.pkg.tar.${EXT} ../vulkan-intel-nano-${ARCH}.pkg.tar.${EXT}
else
	mv -v ./vulkan-broadcom-*.pkg.tar.${EXT}  ../vulkan-broadcom-nano-${ARCH}.pkg.tar.${EXT}
	mv -v ./vulkan-panfrost-*.pkg.tar.${EXT}  ../vulkan-panfrost-nano-${ARCH}.pkg.tar.${EXT}
	mv -v ./vulkan-freedreno-*.pkg.tar.${EXT} ../vulkan-freedreno-nano-${ARCH}.pkg.tar.${EXT}
fi
cd ..
rm -rf ./mesa
echo "All done!"

