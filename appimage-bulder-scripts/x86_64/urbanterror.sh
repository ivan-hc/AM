#!/bin/sh

APP=urbanterror

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

DOWNLOAD_PAGE=$(curl -Ls https://www.urbanterror.info/downloads/)
DOWNLOAD_URL=$(echo "$DOWNLOAD_PAGE" | tr '">< ' '\n' | grep -i "^http.*full.*zip$" | head -1)
VERSION=$(echo "$DOWNLOAD_PAGE" | tr '><' '\n' | grep -i "version [0-9]" | head -1 | tr ' ' '\n' | grep "^[0-9]")
if ! test -f ./*.zip; then curl -#Lo "$APP".zip "$DOWNLOAD_URL"; fi
mkdir -p "$APP".AppDir || exit 1

# Extract the package
unzip -qq ./*zip 1>/dev/null && rm -f ./*zip && mv ./UrbanTerror*/* "$APP".AppDir/ || exit 1

_appimage_basics() {
	# Icon
	curl -#Lo "$APP".png https://aur.archlinux.org/cgit/aur.git/plain/urbanterror.png?h=urbanterror 2>/dev/null && mv "$APP".png "$APP".AppDir/
	
	# Launcher
	cat <<-HEREDOC >> ./"$APP".AppDir/"$APP".desktop
	[Desktop Entry]
	Name=Urban Terror
	Type=Application
	Categories=Game;
	Terminal=false
	Exec=$APP
	Icon=$APP
	HEREDOC

	# AppRun
	printf '#!/bin/sh\nHERE="$(dirname "$(readlink -f "${0}")")"\nexec "${HERE}"/Quake3-UrT.x86_64 "$@"' > ./"$APP".AppDir/AppRun && chmod a+x ./"$APP".AppDir/AppRun
}

_appimage_basics

# CONVERT THE APPDIR TO AN APPIMAGE
ARCH=x86_64 VERSION="$VERSION" _appimagetool -s ./"$APP".AppDir 2>&1
if ! test -f ./*.AppImage; then
	echo "No AppImage available."; exit 1
fi
