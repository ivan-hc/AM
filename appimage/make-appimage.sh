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
cp /bin/curl "$APPDIR"/bin/.
cp /bin/wget "$APPDIR"/bin/.
cp /bin/grep "$APPDIR"/bin/.
cp /bin/sed "$APPDIR"/bin/.
cp /bin/cat "$APPDIR"/bin/.
cp /bin/chmod "$APPDIR"/bin/.
cp /bin/chown "$APPDIR"/bin/.
cp /bin/7z "$APPDIR"/bin/.
cp /bin/ar "$APPDIR"/bin/.
cp /bin/column "$APPDIR"/bin/.
cp /bin/du "$APPDIR"/bin/.
cp /bin/sha1sum "$APPDIR"/bin/.
cp /bin/sha512sum "$APPDIR"/bin/.
cp /bin/sha256sum "$APPDIR"/bin/.
cp /bin/md5sum "$APPDIR"/bin/.
cp /bin/tar "$APPDIR"/bin/.
cp /bin/unxz "$APPDIR"/bin/.
cp /bin/unzip "$APPDIR"/bin/.
cp /bin/xz "$APPDIR"/bin/.
cp /bin/xzcat "$APPDIR"/bin/.
chmod a+x "$APPDIR"/bin/*

# Deploy dependencies
quick-sharun "$APPDIR"

# Turn AppDir into AppImage
quick-sharun --make-appimage

# Rename files
mv -f dist/*-$ARCH.AppImage dist/APP-MANAGER-$ARCH.AppImage
mv -f dist/*-$ARCH.AppImage.zsync dist/APP-MANAGER-$ARCH.AppImage.zsync

# Test the app for 12 seconds
quick-sharun --simple-test dist/*.AppImage

