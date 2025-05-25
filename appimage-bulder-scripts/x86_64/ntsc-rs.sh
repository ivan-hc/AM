#!/bin/sh

APP=ntsc-rs

ARCH="x86_64"

# DEPENDENCIES

dependencies="unzip"
for d in $dependencies; do
	if ! command -v "$d" 1>/dev/null; then
		echo "ERROR: missing command \"d\", install the above and retry" && exit 1
	fi
done

_appimagetool() {
	if ! command -v appimagetool 1>/dev/null; then
		[ ! -f ./appimagetool ] && curl -#Lo appimagetool https://github.com/AppImage/appimagetool/releases/download/continuous/appimagetool-"$ARCH".AppImage && chmod a+x ./appimagetool
		./appimagetool "$@"
	else
		appimagetool "$@"
	fi
}

DOWNLOAD_PAGE=$(curl -Ls https://api.github.com/repos/valadaptive/ntsc-rs/releases/latest)
DOWNLOAD_URL=$(echo "$DOWNLOAD_PAGE" | tr '><" ' '\n' |  grep -i "^https.*github.com.*download.*linux-standalone.*zip$" | head -1)
VERSION=$(echo "$DOWNLOAD_URL" | tr '/' '\n' | grep "^v[0-9]\|^[0-9]" | head -1)
[ ! -f "$APP".zip ] && curl -#Lo "$APP".zip "$DOWNLOAD_URL"
mkdir -p "$APP".AppDir || exit 1

# Extract the package
unzip -qq ./*.zip && chmod a+x ./ntsc*/* && mv ./ntsc*/* "$APP".AppDir/ || exit 1

_appimage_basics() {
	# Launcher
	cat <<-HEREDOC >> ./"$APP".AppDir/"$APP".desktop
	[Desktop Entry]
	Name=ntsc-rs
	Comment=Free, open-source VHS effect (Standalone application)
	Exec=ntsc-rs-standalone %U
	Icon=ntsc-rs
	Type=Application
	StartupWMClass=ntsc-rs
	Categories=AudioVideo;AudioVideoEditing
	HEREDOC

	# Icon
	wget -q https://raw.githubusercontent.com/valadaptive/ntsc-rs/main/assets/icon.svg -O ./"$APP".AppDir/"$APP".svg

	# AppRun
	cat <<-'HEREDOC' >> ./"$APP".AppDir/AppRun
	#!/bin/sh
	HERE="$(dirname "$(readlink -f "${0}")")"
	case "$1" in
		'') exec "${HERE}"/ntsc-rs-standalone "$@";;
		*) exec "${HERE}"/ntsc-rs-cli "$@";;
	esac
	HEREDOC
	chmod a+x ./"$APP".AppDir/AppRun
}

_appimage_basics

# CONVERT THE APPDIR TO AN APPIMAGE
ARCH=x86_64 VERSION="$VERSION" _appimagetool -s ./"$APP".AppDir 2>&1
if ! test -f ./*.AppImage; then
	echo "No AppImage available."; exit 1
fi
