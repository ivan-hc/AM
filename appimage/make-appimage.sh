#!/bin/sh

set -eu

ARCH=$(uname -m)
export ARCH

# This script is meant to be run from the repository root (the CI checks it
# out), so the checkout itself is the source for the AppImage. This way a
# pull request that changes APP-MANAGER produces an AppImage of that same
# code, and the resulting AppImage can be tested before merging.
UPSTREAM_DIR="$PWD"
APP_DIR="$PWD/AppDir"
export APP_DIR

echo "---------------------------------------------------------------"
echo "Building the \"AM\" AppImage..."
echo "---------------------------------------------------------------"

VERSION=$(grep -m1 '^AMVERSION=' "$UPSTREAM_DIR/APP-MANAGER" | sed 's/.*="\([^"]*\)".*/\1/')
[ -n "$VERSION" ] || { echo "ERROR: could not determine the version!"; exit 1; }
export VERSION
echo "Version: $VERSION"

echo "---------------------------------------------------------------"
echo "Preparing AppDir..."
echo "---------------------------------------------------------------"
rm -rf "$APP_DIR"
mkdir -p "$APP_DIR/bin"

# Desktop entry + icon
cp "$PWD/appimage/APP-MANAGER.desktop" "$APP_DIR/APP-MANAGER.desktop"
cp "$PWD/logo.png" "$APP_DIR/logo.png"

# Main executable: the APP-MANAGER, named 'appman' so it runs in
# portable/AppMan mode. AppDir/bin is prepended to PATH by the generated
# AppRun, so all bundled tools below are found by AM automatically.
cp "$UPSTREAM_DIR/APP-MANAGER" "$APP_DIR/bin/appman"
chmod a+x "$APP_DIR/bin/appman"

# Upstream installer, reachable via `AM-*.AppImage setup`. INSTALL is renamed
# "INSTALL-AM-APPIMAGE.sh" so that INSTALL itself detects the AppImage flow
# (see the top of INSTALL) and installs this very AppImage as "am".
cp "$UPSTREAM_DIR/INSTALL" "$APP_DIR/INSTALL-AM-APPIMAGE.sh"
cp "$UPSTREAM_DIR/AM-INSTALLER" "$APP_DIR/AM-INSTALLER"
chmod a+x "$APP_DIR/INSTALL-AM-APPIMAGE.sh" "$APP_DIR/AM-INSTALLER"

# Bundle the static appimageupdatetool binary (pkgforge-dev/AppImageUpdate),
# so that the AppImage can update itself in place (see "_sync_amcli" in
# APP-MANAGER). It is a self-contained static binary, so it only needs to be
# placed in $APP_DIR/bin - no libraries to bundle with it.
echo "---------------------------------------------------------------"
echo "Bundling appimageupdatetool..."
echo "---------------------------------------------------------------"
APPIMAGEUPDATETOOL_LINK="${APPIMAGEUPDATETOOL_LINK:-https://github.com/pkgforge-dev/AppImageUpdate/releases/latest/download/appimageupdate-$ARCH-linux}"
if command -v wget >/dev/null 2>&1; then
	wget -q -O "$APP_DIR/bin/appimageupdatetool" "$APPIMAGEUPDATETOOL_LINK" \
		&& chmod a+x "$APP_DIR/bin/appimageupdatetool" \
		|| echo "  WARNING: could not download appimageupdatetool, skipping"
elif command -v curl >/dev/null 2>&1; then
	curl -sL -o "$APP_DIR/bin/appimageupdatetool" "$APPIMAGEUPDATETOOL_LINK" \
		&& chmod a+x "$APP_DIR/bin/appimageupdatetool" \
		|| echo "  WARNING: could not download appimageupdatetool, skipping"
else
	echo "  WARNING: neither wget nor curl available, not bundling appimageupdatetool"
fi

# Our hooks (run before/after the bundled self-updater hook)
cp "$PWD"/appimage/hooks/*.hook "$APP_DIR/bin/"

echo "---------------------------------------------------------------"
echo "Deploying with quick-sharun..."
echo "---------------------------------------------------------------"
export OUTPATH="$PWD/dist"
export ADD_HOOKS="self-updater.hook"
export UPINFO="gh-releases-zsync|${GITHUB_REPOSITORY%/*}|${GITHUB_REPOSITORY#*/}|latest|*$ARCH.AppImage.zsync"
export ICON="$PWD/logo.png"
export DESKTOP="$PWD/appimage/APP-MANAGER.desktop"

# Deploy the 'appman' script together with the tools that AM may call but
# that are missing from some distros (curl, wget, 7z, tar, unzip, xz, ...).
# quick-sharun bundles each binary together with its libraries and glibc
# (DEPLOY_GLIBC is enabled automatically), which makes the resulting
# AppImage fully self-contained and portable. Set DEPLOY_AM_DEPS=0 to skip
# this and rely on AM's built-in fallback.
if [ "${DEPLOY_AM_DEPS:-1}" = 1 ]; then
	DEP_DEPS="
		/usr/bin/curl
		/usr/bin/wget
		/usr/lib/7zip/7z
		/usr/bin/ar
		/usr/bin/column
		/usr/bin/du
		/usr/bin/file
		/usr/bin/md5sum
		/usr/bin/mv
		/usr/bin/sha1sum
		/usr/bin/sha256sum
		/usr/bin/sha512sum
		/usr/bin/tar
		/usr/bin/unxz
		/usr/bin/unzip
		/usr/bin/xz
		/usr/bin/xzcat
		/usr/bin/cat
		/usr/bin/chmod
		/usr/bin/chown
		/usr/bin/grep
		/usr/bin/sed
	"
	set -- "$APP_DIR/bin/appman" $DEP_DEPS
else
	set -- "$APP_DIR/bin/appman"
fi
# Warn (but keep going) if a bundled dependency is not present on the
# build system - quick-sharun would silently skip missing files.
for d do
	[ -e "$d" ] || echo "  WARNING: $d not found, not bundling it"
done
quick-sharun "$@"

echo "---------------------------------------------------------------"
echo "Making the AppImage..."
echo "---------------------------------------------------------------"
quick-sharun --make-appimage

echo "---------------------------------------------------------------"
echo "Testing the AppImage..."
echo "---------------------------------------------------------------"
# uruntime falls back to extract-and-run when FUSE is unavailable (CI)
export APPIMAGE_EXTRACT_AND_RUN=1 APPIMAGE_TARGET_DIR="$PWD/_test-app"
# AM is a CLI that exits immediately, so use --simple-test (the full --test
# expects the app to stay running for 12 seconds).
quick-sharun --simple-test ./dist/*.AppImage -v