#!/bin/sh

APP=filezilla-server

ARCH="x86_64"

# DEPENDENCIES

dependencies="tar"
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

DOWNLOAD_PAGE=$(curl -Ls https://sourceforge.net/projects/fabiololix-os-archive/files/src/)
DOWNLOAD_URL=$(echo "$DOWNLOAD_PAGE" | tr ' ><"' '\n' | grep -i "^http.*linux.*tar" | head -1)
VERSION=$(echo "$DOWNLOAD_URL" | tr '_' '\n' | grep "^[0-9].*.[0-9]" | head -1)
if [ ! -f "$APP".tar.xz ]; then
	curl -#Lo "$APP".tar.xz "$DOWNLOAD_URL" || exit 1
	tar xf ./*tar.xz
fi
mkdir -p "$APP".AppDir || exit 1

# Extract the package
cp -r ./F*/* "$APP".AppDir/

_appimage_basics() {
	# Launcher
	cat <<-HEREDOC >> ./"$APP".AppDir/"$APP".desktop
	[Desktop Entry]
	Name=FileZilla Server
	GenericName=FTP client
	GenericName[da]=FTP-klient
	GenericName[de]=FTP-Client
	GenericName[fr]=Client FTP
	Comment=Download and upload files via FTP, FTPS and SFTP
	Comment[da]=Download og upload filer via FTP, FTPS og SFTP
	Comment[de]=Dateien über FTP, FTPS und SFTP übertragen
	Comment[fr]=Transférer des fichiers via FTP, FTPS et SFTP
	Exec=filezilla-server-gui
	Terminal=false
	Icon=filezilla-server-gui
	Type=Application
	Categories=Network;FileTransfer;
	Version=1.0
	HEREDOC
	rm -f "$APP".AppDir/freedownloadmanager.desktop

	# AppRun
	cat <<-'HEREDOC' >> ./"$APP".AppDir/AppRun
	#!/bin/sh
	HERE="$(dirname "$(readlink -f "${0}")")"

	export PATH="${HERE}"/bin/:"${PATH}"
	export LD_LIBRARY_PATH="${HERE}"/lib/:"${LD_LIBRARY_PATH}"
	export XDG_DATA_DIRS="${HERE}"/share/:"${XDG_DATA_DIRS}"

	case "$1" in
	  '') "${HERE}"/bin/filezilla-server-gui "$@";;
	  *) "${HERE}"/bin/filezilla-server "$@";;
	esac
	HEREDOC
	chmod a+x ./"$APP".AppDir/AppRun

	# Icon
	cp -r "$APP".AppDir/share/icons/hicolor/256x256/apps/* "$APP".AppDir/filezilla-server-gui.png || exit 1
}

_appimage_basics

# CONVERT THE APPDIR TO AN APPIMAGE
ARCH=x86_64 VERSION="$VERSION" _appimagetool -s ./"$APP".AppDir 2>&1
if ! test -f ./*.AppImage; then
	echo "No AppImage available."; exit 1
fi
