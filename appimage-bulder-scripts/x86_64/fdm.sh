#!/bin/sh

APP=fdm

_appimage_basics() {
	# Launcher
	rm -f "$APP".AppDir/freedownloadmanager.desktop
	cat <<-HEREDOC >> ./"$APP".AppDir/"$APP".desktop
	[Desktop Entry]
	Name=Free Download Manager
	Comment= FDM is a powerful modern download accelerator and organizer
	Keywords=download;manager;free;fdm;
	Exec=$APP
	Terminal=false
	Type=Application
	Icon=icon
	Categories=Network;FileTransfer;P2P;GTK;
	StartupNotify=true
	HEREDOC

	# AppRun
	printf '#!/bin/sh\nHERE="$(dirname "$(readlink -f "${0}")")"\nexec "${HERE}"/%b "$@"' "$APP" > ./"$APP".AppDir/AppRun && chmod a+x ./"$APP".AppDir/AppRun
}

ARCH="x86_64"

# DEPENDENCIES
[ ! -f ./appimagetool ] && curl -#Lo appimagetool https://github.com/AppImage/appimagetool/releases/download/continuous/appimagetool-"$ARCH".AppImage && chmod a+x ./appimagetool

DOWNLOAD_PAGE=$(curl -Ls https://www.freedownloadmanager.org/download-fdm-for-linux.htm)
DOWNLOAD_URL=$(echo "$DOWNLOAD_PAGE" | tr '">< ' '\n' | grep "http.*deb$" | grep -vi "qt" | head -1)
VERSION=$(echo "$DOWNLOAD_PAGE" | grep "FDM [0-9]" | tr '><" ' '\n' | grep "^[0-9]" | head -1)
[ ! -f "$APP".deb ] && curl -#Lo "$APP".deb "$DOWNLOAD_URL" && mkdir -p "$APP".AppDir && ar x ./*.deb && tar fx ./data.tar* && mv ./opt/*/* "$APP".AppDir/ || exit 1
_appimage_basics

# CONVERT THE APPDIR TO AN APPIMAGE
ARCH=x86_64 VERSION="$VERSION" ./appimagetool -s ./"$APP".AppDir 2>&1
test -f ./*.Appimage && rm -Rf ./*.deb ./*.AppDir ./*tar*
