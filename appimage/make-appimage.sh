#!/bin/sh
set -eu

# Parameters
ARCH=$1
VERSION=$2
export ARCH VERSION
export OUTPATH=dist
#export ADD_HOOKS="self-updater.hook"
export GITHUB_REPOSITORY="https://github.com/ivan-hc/AM"
export UPINFO="gh-releases-zsync|${GITHUB_REPOSITORY%/*}|${GITHUB_REPOSITORY#*/}|latest|*$ARCH.AppImage.zsync"
export ICON=logo.svg
export DESKTOP=appimage/APP-MANAGER.desktop
export MAIN_BIN=AppRun
export APPDIR="AppDir-$VERSION-$ARCH"

# Prepare files
rm -Rf "$APPDIR"/*
mkdir -p "$APPDIR"/bin "$APPDIR"/share
# Copy AM files
cp appimage/AppRun "$APPDIR"/.
cp APP-MANAGER "$APPDIR"/bin/.
cp AM-INSTALLER "$APPDIR"/bin/.
cp INSTALL "$APPDIR"/bin/INSTALL-AM-APPIMAGE.sh
cp -rf modules "$APPDIR"/share/.
# Copy coreutils
#wget -q https://github.com/ivan-hc/am-utils/releases/download/continuous-"$ARCH"/chown-"$ARCH"-static -O "$APPDIR"/bin/chown
cp /bin/curl  "$APPDIR"/bin/curl
cp /bin/grep  "$APPDIR"/bin/grep
cp /bin/sed   "$APPDIR"/bin/sed
cp /bin/cat   "$APPDIR"/bin/cat
cp /bin/chmod "$APPDIR"/bin/chmod
cp /bin/chown "$APPDIR"/bin/chown
chmod a+x "$APPDIR"/bin/*

# Deploy dependencies
quick-sharun "$APPDIR"

# Turn AppDir into AppImage
quick-sharun --make-appimage

# Test the app for 12 seconds
quick-sharun --simple-test dist/*.AppImage

