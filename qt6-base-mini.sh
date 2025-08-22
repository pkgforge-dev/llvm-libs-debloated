#!/bin/sh

set -ex

ARCH="$(uname -m)"

sed -i -e 's|-O2|-Os|' /etc/makepkg.conf

git clone https://gitlab.archlinux.org/archlinux/packaging/packages/qt6-base qt6-base
cd ./qt6-base

case "$ARCH" in
	'x86_64')
		EXT='zst'
		;;
	'aarch64')
		EXT='xz'
		sed -i -e 's/-DFEATURE_no_direct_extern_access=ON/-DQT_FEATURE_sql_ibase=OFF/' ./PKGBUILD
		;;
	*)
		echo "Unsupported Arch: '$ARCH'"
		exit 1
		;;
esac
sed -i -e "s|x86_64|$ARCH|" ./PKGBUILD

# remove the line that enables icu support
sed -i \
	-e 's/-DCMAKE_BUILD_TYPE=RelWithDebInfo/-DCMAKE_BUILD_TYPE=MinSizeRel/' \
	-e 's/-DFEATURE_journald=ON/-DFEATURE_journald=OFF/'                    \
	-e '/-DFEATURE_libproxy=ON \\/a\    -DFEATURE_icu=OFF \\'               \
	./PKGBUILD
cat ./PKGBUILD

makepkg -fs --noconfirm --skippgpcheck
ls -la
rm -fv ./*-docs-*.pkg.tar.* ./*-debug-*.pkg.tar.*
mv -v ./qt6-base-*.pkg.tar."$EXT" ../qt6-base-mini-"$ARCH".pkg.tar."$EXT"
cd ..
rm -rf ./qt6-base
# keep older name to not break existing CIs
cp -v ./qt6-base-mini-"$ARCH".pkg.tar."$EXT" ./qt6-base-iculess-"$ARCH".pkg.tar."$EXT"
echo "All done!"
