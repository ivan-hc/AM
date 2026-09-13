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
cp -Lf /bin/7z "$APPDIR"/bin/.
cp -Lf /bin/ar "$APPDIR"/bin/.
cp -Lf /bin/cat "$APPDIR"/bin/.
cp -Lf /bin/chmod "$APPDIR"/bin/.
cp -Lf /bin/chown "$APPDIR"/bin/.
cp -Lf /bin/column "$APPDIR"/bin/.
cp -Lf /bin/curl "$APPDIR"/bin/.
cp -Lf /bin/du "$APPDIR"/bin/.
cp -Lf /bin/file "$APPDIR"/bin/.
cp -Lf /bin/grep "$APPDIR"/bin/.
cp -Lf /bin/md5sum "$APPDIR"/bin/.
cp -Lf /bin/sed "$APPDIR"/bin/.
cp -Lf /bin/sha1sum "$APPDIR"/bin/.
cp -Lf /bin/sha256sum "$APPDIR"/bin/.
cp -Lf /bin/sha512sum "$APPDIR"/bin/.
cp -Lf /bin/tar "$APPDIR"/bin/.
cp -Lf /bin/unxz "$APPDIR"/bin/.
cp -Lf /bin/unzip "$APPDIR"/bin/.
cp -Lf /bin/wget "$APPDIR"/bin/.
cp -Lf /bin/xz "$APPDIR"/bin/.
cp -Lf /bin/xzcat "$APPDIR"/bin/.
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

