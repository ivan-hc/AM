#!/bin/sh

APP=fdm

ARCH="x86_64"

# DEPENDENCIES

dependencies="ar tar"
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

DOWNLOAD_PAGE=$(curl -Ls https://www.freedownloadmanager.org/download-fdm-for-linux.htm)
DOWNLOAD_URL=$(echo "$DOWNLOAD_PAGE" | tr '">< ' '\n' | grep "http.*deb$" | grep -vi "qt" | head -1)
VERSION=$(echo "$DOWNLOAD_PAGE" | grep "FDM [0-9]" | tr '><" ' '\n' | grep "^[0-9]" | head -1)
[ ! -f "$APP".deb ] && curl -#Lo "$APP".deb "$DOWNLOAD_URL"
mkdir -p "$APP".AppDir || exit 1

# Extract the package
ar x ./*.deb && tar fx ./data.tar* && mv ./opt/*/* "$APP".AppDir/ || exit 1

_appimage_basics() {
	# Launcher
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
	rm -f "$APP".AppDir/freedownloadmanager.desktop

	# AppRun
	printf '#!/bin/sh\nHERE="$(dirname "$(readlink -f "${0}")")"\nexec "${HERE}"/%b "$@"' "$APP" > ./"$APP".AppDir/AppRun && chmod a+x ./"$APP".AppDir/AppRun
}

_appimage_basics

# CONVERT THE APPDIR TO AN APPIMAGE
ARCH=x86_64 VERSION="$VERSION" _appimagetool -s ./"$APP".AppDir 2>&1
if ! test -f ./*.AppImage; then
	echo "No AppImage available."; exit 1
fi
