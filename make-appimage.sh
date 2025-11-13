#!/bin/sh

set -eu

ARCH=$(uname -m)
VERSION=$(pacman -Q kicad | awk '{print $2; exit}') # example command to get version of application here
export ARCH VERSION
export OUTPATH=./dist
export ADD_HOOKS="self-updater.bg.hook"
export UPINFO="gh-releases-zsync|${GITHUB_REPOSITORY%/*}|${GITHUB_REPOSITORY#*/}|latest|*$ARCH.AppImage.zsync"
export ICON=/usr/share/icons/hicolor/128x128/apps/kicad.png
export DESKTOP=/usr/share/applications/org.kicad.kicad.desktop
export DEPLOY_OPENGL=1
export DEPLOY_SYS_PYTHON=1
# app is hardcoded to look into /usr/share, does not check XDG_DATA_DIRS
export PATH_MAPPING='/usr/share/kicad:${SHARUN_DIR}/share/kicad'

# Deploy dependencies
quick-sharun \
	/usr/bin/_cvpcb.kiface          \
	/usr/bin/_eeschema.kiface       \
	/usr/bin/_gerbview.kiface       \
	/usr/bin/_kipython.kiface       \
	/usr/bin/_pcb_calculator.kiface \
	/usr/bin/_pcbnew.kiface         \
	/usr/bin/_pl_editor.kiface      \
	/usr/bin/bitmap2component       \
	/usr/bin/dxf2idf                \
	/usr/bin/eeschema               \
	/usr/bin/gerbview               \
	/usr/bin/idf2vrml               \
	/usr/bin/idfcyl                 \
	/usr/bin/idfrect                \
	/usr/bin/pcb_calculator         \
	/usr/bin/pcbnew                 \
	/usr/bin/pl_editor              \
	/usr/bin/kicad                  \
	/usr/bin/kicad-cli              \
	/usr/lib/kicad/*/*/*

mkdir -p ./AppDir/share/applications
cp /usr/share/applications/*kicad* ./AppDir/share/applications

# some binaries are actually libraries!
mv -fv ./AppDir/shared/bin/_* ./AppDir/bin

# Turn AppDir into AppImage
quick-sharun --make-appimage
