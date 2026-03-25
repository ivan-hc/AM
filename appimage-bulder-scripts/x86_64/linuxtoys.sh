#!/bin/sh

APP=linuxtoys

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

DOWNLOAD_PAGE=$(curl -Ls https://api.github.com/repos/psygreg/linuxtoys/releases)
DOWNLOAD_URL=$(echo "$DOWNLOAD_PAGE" | tr '><" ' '\n' |  grep -i "^https.*github.com.*download.*tar.xz$" | head -1)
VERSION=$(echo "$DOWNLOAD_URL" | tr '/' '\n' | grep "^v[0-9]\|^[0-9]" | head -1)
[ ! -f "$APP".tar.xz  ] && curl -#Lo "$APP".tar.xz  "$DOWNLOAD_URL"
mkdir -p "$APP".AppDir || exit 1

# Extract the package
tar fx ./*tar* && mv ./"$APP"*/* "$APP".AppDir/ || exit 1

_appimage_basics() {
	# AppRun
	rm -f ./"$APP".AppDir/AppRun
	cat <<-'HEREDOC' >> ./"$APP".AppDir/AppRun
	#!/bin/sh
	HERE="$(dirname "$(readlink -f "${0}")")"
	if test -d "${HERE}"/usr/lib/python*; then
	  PYTHONVERSION=$(find /usr/lib -type d -name "python*" | head -1 | sed 's:.*/::')
	  export XDG_DATA_DIRS="${HERE}"/usr/share/:"${XDG_DATA_DIRS}"
	  export PYTHONPATH=/usr/lib/"$PYTHONVERSION"/site-packages/:/usr/lib/"$PYTHONVERSION"/lib-dynload/:"${PYTHONPATH}"
	  export PYTHONHOME="${HERE}"/usr/
	fi
	# Set process name for better desktop integration
	export LINUXTOYS_PROCESS_NAME="linuxtoys"
	cd "${HERE}"/usr/share/linuxtoys
	exec /usr/bin/python3 run.py "$@"
	HEREDOC
	chmod a+x ./"$APP".AppDir/AppRun

	# Desktop file
	cp -r ./"$APP".AppDir/usr/share/applications/*.desktop ./"$APP".AppDir/

	# Icon
	cp -r ./"$APP".AppDir/usr/share/icons/hicolor/scalable/apps/* ./"$APP".AppDir/
}

_appimage_basics

# CONVERT THE APPDIR TO AN APPIMAGE
ARCH=x86_64 VERSION="$VERSION" _appimagetool -s ./"$APP".AppDir 2>&1
if ! test -f ./*.AppImage; then
	echo "No AppImage available."; exit 1
fi
