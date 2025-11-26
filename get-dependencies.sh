#!/bin/sh

set -eu

ARCH=$(uname -m)

echo "Installing package dependencies..."
echo "---------------------------------------------------------------"
pacman -Syu --noconfirm kicad kicad-library protobuf

echo "Installing debloated packages..."
echo "---------------------------------------------------------------"
get-debloated-pkgs --add-common --prefer-nano

if [ "$ARCH" = 'aarch64'] && [ -f /usr/lib/libprotobuf.so ] \
  && [ ! -f /usr/lib/libprotobuf.so.32.0.0 ]; then
	cp /usr/lib/libprotobuf.so /usr/lib/libprotobuf.so.32.0.0
fi

# Comment this out if you need an AUR package
#get-aur-package PACKAGENAME

# If the application needs to be manually built that has to be done down here
