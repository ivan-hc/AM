#!/bin/sh

set -eu

ARCH=$(uname -m)

# Defensive: this script can be run from inside an AppImage environment
# (e.g. a FUSE-mounted shell/editor) which exports APPDIR/APPIMAGE and
# friends pointing at the outer AppImage. Ignore any inherited values.
unset APPDIR APPIMAGE APPIMAGE_ARCH APPIMAGE_TARGET_DIR APPIMAGE_EXTRACT_AND_RUN \
	ARG0 ARGV0 SHARUN_DIR SHARUN_LIB_DIR HOST_PATH 2>/dev/null || :

export ARCH APPIMAGE_ARCH="$ARCH"

# This script is meant to be run from the repository root (the CI checks it
# out), so the checkout itself is the source for the AppImage. This way a
# pull request that changes APP-MANAGER produces an AppImage of that same
# code, and the resulting AppImage can be tested before merging.
UPSTREAM_DIR="$PWD"
APPDIR="$PWD/AppDir"
export APPDIR

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
rm -rf "$APPDIR"
mkdir -p "$APPDIR/bin"

# Desktop entry + icon
cp "$PWD/appimage/APP-MANAGER.desktop" "$APPDIR/APP-MANAGER.desktop"
cp "$PWD/logo.png" "$APPDIR/logo.png"

# Main executable: the APP-MANAGER, named 'appman' so it runs in
# portable/AppMan mode. AppDir/bin is prepended to PATH by the generated
# AppRun, so all bundled tools below are found by AM automatically.
cp "$UPSTREAM_DIR/APP-MANAGER" "$APPDIR/bin/appman"
chmod a+x "$APPDIR/bin/appman"

# Upstream installer, reachable via `AM-*.AppImage setup`
cp "$UPSTREAM_DIR/INSTALL" "$UPSTREAM_DIR/AM-INSTALLER" "$APPDIR/"
chmod a+x "$APPDIR/INSTALL" "$APPDIR/AM-INSTALLER"

# Our hooks (run before/after the bundled self-updater hook)
cp "$PWD"/appimage/hooks/*.hook "$APPDIR/bin/"

echo "---------------------------------------------------------------"
echo "Deploying with quick-sharun..."
echo "---------------------------------------------------------------"
export OUTPATH="$PWD/dist"
export ADD_HOOKS="self-updater.hook"
export UPINFO="gh-releases-zsync|${GITHUB_REPOSITORY%/*}|${GITHUB_REPOSITORY#*/}|latest|*$ARCH.AppImage.zsync"
export ICON="$PWD/logo.png"
export DESKTOP="$PWD/appimage/APP-MANAGER.desktop"
# TEMPORARY: quick-sharun still defaults to sharun 2.3.0, which does not
# ship builds for riscv64/loongarch64/ppc64/ppc64le - those were added in
# sharun 3.0.0. This override can be removed once quick-sharun bumps its
# default SHARUN_LINK.
export SHARUN_LINK="${SHARUN_LINK:-https://github.com/pkgforge-dev/sharun/releases/download/3.0.0/sharun-$APPIMAGE_ARCH}"

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
	set -- "$APPDIR/bin/appman" $DEP_DEPS
else
	set -- "$APPDIR/bin/appman"
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