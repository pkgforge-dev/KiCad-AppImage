#!/bin/sh

set -e

QUICK_SHARUN=${QUICK_SHARUN:-https://raw.githubusercontent.com/pkgforge-dev/Anylinux-AppImages/refs/heads/main/useful-tools/quick-sharun.sh}
DEBLOATED_PACKAGES=${DEBLOATED_PACKAGES:-https://raw.githubusercontent.com/pkgforge-dev/Anylinux-AppImages/refs/heads/main/useful-tools/get-debloated-pkgs.sh}
MAKE_AUR_PACKAGE=${MAKE_AUR_PACKAGE:-https://raw.githubusercontent.com/pkgforge-dev/Anylinux-AppImages/refs/heads/main/useful-tools/make-aur-package.sh}
ANYLINUX_TOOLS_DIR=${ANYLINUX_TOOLS_DIR:-/usr/local/bin}

if [ -z "$CI" ] || [ "$(id -u)" != 0 ]; then
	>&2 echo "ERROR: ${0##*/} can only be used in CI a container with root perms!"
	exit 1
elif ! command -v pacman 1>/dev/null; then
	>&2 echo "ERROR: ${0##*/} can only be used on Archlinux based container!"
	exit 1
fi

_get_anylinux_tool() {
	if command -v wget 1>/dev/null; then
		_DLCMD="wget --retry-connrefused --tries=30 -O"
	elif command -v curl 1>/dev/null; then
		_DLCMD="curl --retry-connrefused --retry 30 -Lo"
	else
		>&2 echo "ERROR: We need wget or curl to download the tools"
		exit 1
	fi
	echo "DOWNLOADING '$2' to '$1'"
	$_DLCMD "$@"
}

echo "Installing basic packaging dependencies..."
echo "---------------------------------------------------------------"
pacman-key --init
pacman -Syy --noconfirm archlinux-keyring
pacman -Syu --noconfirm \
	base-devel        \
	curl              \
	git               \
	libx11            \
	libxrandr         \
	libxss            \
	pulseaudio        \
	pulseaudio-alsa   \
	wget              \
	xorg-server-xvfb  \
	zsync

echo "Installing tools..."
echo "---------------------------------------------------------------"
mkdir -p "$ANYLINUX_TOOLS_DIR" ./dist
_get_anylinux_tool "$ANYLINUX_TOOLS_DIR"/quick-sharun       "$QUICK_SHARUN"
_get_anylinux_tool "$ANYLINUX_TOOLS_DIR"/get-debloated-pkgs "$DEBLOATED_PACKAGES"
_get_anylinux_tool "$ANYLINUX_TOOLS_DIR"/make-aur-package   "$MAKE_AUR_PACKAGE"

chmod +x \
	"$ANYLINUX_TOOLS_DIR"/quick-sharun       \
	"$ANYLINUX_TOOLS_DIR"/get-debloated-pkgs \
	"$ANYLINUX_TOOLS_DIR"/make-aur-package

echo "---------------------------------------------------------------"
echo "CONTAINER IS READY!"
echo "---------------------------------------------------------------"
