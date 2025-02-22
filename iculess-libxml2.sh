#!/bin/sh

set -x

ARCH="$(uname -m)"

_build_libxml2() (
	rm -rf ./libxml2 || true
	git clone https://gitlab.archlinux.org/archlinux/packaging/packages/libxml2.git libxml2
	cd ./libxml2

	# remove the line that enables icu support
	# sed -i '/--with-icu/d' ./PKGBUILD
	# They switched to meson, so we will remove the lib directly
	sudo pacman --noconfirm -Rsndd icu

	case "${ARCH}" in
		"x86_64")
			EXT="zst"
			;;
		"aarch64")
			EXT="xz"
			sed -i "s/x86_64/${ARCH}/" ./PKGBUILD
			;;
		*)
			echo "Unsupported Arch: '${ARCH}'"
			exit 1
			;;
	esac
	cat ./PKGBUILD

	makepkg -f --skippgpcheck || return 1
	ls -la
	rm -f ./libxml2-docs-*.pkg.tar.* ./libxml2-debug-*-x86_64.pkg.tar.*
	mv ./libxml2-*.pkg.tar.${EXT} ../libxml2-iculess-${ARCH}.pkg.tar.${EXT} || return 1
	cd ..
	rm -rf ./libxml2
)

COUNT=0
while [ "$COUNT" -le 5 ]; do
	if ! _build_libxml2; then
		COUNT=$((COUNT + 1))
		echo "Failed, trying $COUNT time"
	else
		break
	fi
done

if [ "$COUNT" -gt 5 ]; then
	echo "Failed to build libxml2 5 times"
	exit 1
fi


echo "All done!"
