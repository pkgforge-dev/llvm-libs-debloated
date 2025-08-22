#!/bin/sh

set -ex

ARCH="$(uname -m)"

sed -i -e 's|-O2|-Os|' /etc/makepkg.conf

git clone https://gitlab.archlinux.org/archlinux/packaging/packages/gtk3.git gtk3
cd ./gtk3

case "${ARCH}" in
"x86_64")
	EXT="zst"
	;;
"aarch64")
	EXT="xz"
	;;
*)
	echo "Unsupported Arch: '${ARCH}'"
	exit 1
	;;
esac

sed -i \
	-e '/broadway/d'        \
	-e '/cloudproviders=/d' \
	./PKGBUILD

cat ./PKGBUILD

makepkg -fs --noconfirm --skippgpcheck
ls -la
rm -fv ./*-docs-*.pkg.tar.* ./*-debug-*.pkg.tar.* ./*-demos-*.pkg.tar.*
mv ./gtk3-*.pkg.tar.${EXT} ../gtk3-mini-"$ARCH".pkg.tar."$EXT"
cd ..
rm -rf ./gtk
echo "All done!"
