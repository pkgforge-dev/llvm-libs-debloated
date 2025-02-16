#!/bin/sh

set -ex

ARCH="$(uname -m)"

_build_libxml2() (
	git clone https://gitlab.archlinux.org/archlinux/packaging/packages/libxml2.git libxml2
	cd ./libxml2
	
	# remove the line that enables icu support
	sed -i '/--with-icu/d' ./PKGBUILD
	
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
	
	makepkg -f --skippgpcheck
	ls -la
	rm -f ./libxml2-docs-*.pkg.tar.* ./libxml2-debug-*-x86_64.pkg.tar.* 
	mv ./libxml2-*.pkg.tar.${EXT} ../libxml2-iculess-${ARCH}.pkg.tar.${EXT}
	cd ..
	rm -rf ./libxml2
)

COUNT=0
while [ "$COUNT" -le 5 ]; do
    if ! _build_libxml2; then
        rm -rf ./libxml2 || true
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
