#!/bin/sh

APP=windows95

_appimage_basics() {
	# Launcher
	cat <<-HEREDOC >> ./"$APP".AppDir/"$APP".desktop
	[Desktop Entry]
	Name=windows95
	Comment=Windows 95, in an app. I'm sorry.
	GenericName=windows95
	Exec=windows95 %U
	Icon=windows95
	Type=Application
	StartupNotify=true
	Categories=GNOME;GTK;Utility;
	HEREDOC

	# Icon
	wget -q https://raw.githubusercontent.com/Portable-Linux-Apps/Portable-Linux-Apps.github.io/main/icons/windows95.png -O ./"$APP".AppDir/"$APP".png

	# AppRun
	printf '#!/bin/sh\nHERE="$(dirname "$(readlink -f "${0}")")"\nexec "${HERE}"/usr/bin/%b "$@"' "$APP" > ./"$APP".AppDir/AppRun && chmod a+x ./"$APP".AppDir/AppRun
}

ARCH="x86_64"

# DEPENDENCIES

_appimagetool() {
	if ! command -v appimagetool 1>/dev/null; then
		[ ! -f ./appimagetool ] && curl -#Lo appimagetool https://github.com/AppImage/appimagetool/releases/download/continuous/appimagetool-"$ARCH".AppImage && chmod a+x ./appimagetool
		./appimagetool "$@"
	else
		appimagetool "$@"
	fi
}

DOWNLOAD_PAGE=$(curl -Ls https://raw.githubusercontent.com/felixrieseberg/windows95/refs/heads/master/README.md)
DOWNLOAD_URL=$(echo "$DOWNLOAD_PAGE" | tr '><" ' '\n' |  grep -i "^https.*github.com.*download.*deb$" | grep -i "x64\|amd64\|x86_64" | head -1)
VERSION=$(echo "$DOWNLOAD_URL" | tr '_' '\n' | grep "^[0-9]" | head -1)
[ ! -f "$APP".deb ] && curl -#Lo "$APP".deb "$DOWNLOAD_URL"
mkdir -p "$APP".AppDir/usr || exit 1

# Extract the package
command -v ar 1>/dev/null && ar x ./*.deb && command -v tar 1>/dev/null && tar fx ./data.tar* && mv ./usr/* "$APP".AppDir/usr/ || exit 1
_appimage_basics

# CONVERT THE APPDIR TO AN APPIMAGE
ARCH=x86_64 VERSION="$VERSION" _appimagetool -s ./"$APP".AppDir 2>&1
if ! test -f ./*.AppImage; then
	echo "No AppImage available."; exit 1
fi