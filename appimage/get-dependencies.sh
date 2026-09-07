#!/bin/sh

set -eu

ARCH=$(uname -m)

echo "Installing package dependencies..."
echo "---------------------------------------------------------------"
# "AM" is a shell script, so no GUI/mesa/etc libraries need to be bundled
# into the AppImage. We install the tools that AM may call (and that are
# missing on some distros) so that quick-sharun can bundle them - together
# with their libraries and glibc - into the AppImage. This makes the
# resulting AppImage fully self-contained.
pacman -S --noconfirm --needed \
	base-devel \
	ca-certificates \
	curl \
	file \
	git \
	jq \
	tar \
	unzip \
	wget \
	xz \
	7zip

# If you ever need to bundle extra libraries from the (debloated) Arch
# packages, uncomment the line below. It is NOT needed for this app.
#get-debloated-pkgs --add-common --prefer-nano

# Comment this out if you need an AUR package
#make-aur-package PACKAGENAME

# If the application needs to be manually built that has to be done down here

# if you also have to make nightly releases check for DEVEL_RELEASE = 1
#
# if [ "${DEVEL_RELEASE-}" = 1 ]; then
# 	nightly build steps
# else
# 	regular build steps
# fi