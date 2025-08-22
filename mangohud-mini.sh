#!/bin/sh

set -ex

ARCH="$(uname -m)"

sed -i -e 's|-O2|-Oz|' /etc/makepkg.conf

git clone https://github.com/VHSgunzo/mangohud-PKGBUILD.git ./mangohud-temp
mv -v ./mangohud-temp/mangohud ./
rm -rf ./mangohud-temp

cd ./mangohud

case "$ARCH" in
	'x86_64')
		EXT='zst'
		;;
	'aarch64')
		EXT='xz'
		# remove libxnvctrl since it is not possible in aarch64
		sed -i \
			-e 's|-Dmangohudctl=true|-Dmangohudctl=true -Dwith_xnvctrl=disabled|' \
			-e '/libxnvctrl/d' ./PKGBUILD
		;;
	*)
		echo "Unsupported Arch: '$ARCH'"
		exit 1
		;;
esac
sed -i -e "s|x86_64|$(uname -m)|" ./PKGBUILD
cat ./PKGBUILD

makepkg -fs --noconfirm --skippgpcheck
ls -la
rm -fv ./*-docs-*.pkg.tar.* ./*-debug-*.pkg.tar.*
mv -v ./mangohud-*.pkg.tar."$EXT" ../mangohud-mini-"$ARCH".pkg.tar."$EXT"
cd ..
rm -rf ./mangohud
echo "All done!"
