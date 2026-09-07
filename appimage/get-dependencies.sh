#!/bin/sh

set -eu

ARCH=$(uname -m)

echo "Initializing the build container..."
echo "---------------------------------------------------------------"
pacman-key --init
pacman -Syy --noconfirm archlinux-keyring
pacman -Syu --noconfirm

echo "Installing package dependencies..."
echo "---------------------------------------------------------------"
# "AM" is a shell script, so no GUI/mesa/etc libraries need to be bundled
# into the AppImage. We install the tools that AM may call (and that are
# missing on some distros) so that quick-sharun can bundle them - together
# with their libraries and glibc - into the AppImage.
#
# The required set is present on every architecture (Arch Linux ports).
pacman -S --noconfirm --needed \
	base-devel \
	ca-certificates \
	curl \
	git \
	jq \
	patchelf \
	tar \
	unzip \
	wget \
	xz

# Optional packages may not exist on every architecture port. If they are
# missing here, quick-sharun (see make-appimage.sh) warns and skips them,
# and AM falls back to its built-in mechanism for those commands.
# xorg-server-xvfb is only used by quick-sharun's strace mode to provide a
# virtual display (our CLI tools do not need one, so it is just a warning
# if unavailable).
pacman -S --noconfirm --needed 7zip file xorg-server-xvfb \
	|| echo "  WARNING: some optional packages are not available on $ARCH"

echo "Installing quick-sharun..."
echo "---------------------------------------------------------------"
wget -q -O /usr/local/bin/quick-sharun \
	https://raw.githubusercontent.com/pkgforge-dev/Anylinux-AppImages/refs/heads/main/useful-tools/quick-sharun.sh
chmod a+x /usr/local/bin/quick-sharun

echo "CONTAINER IS READY!"