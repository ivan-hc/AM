#!/bin/sh

APP=fdm

# DOWNLOADING THE DEPENDENCIES
if test -f ./appimagetool; then
	echo " appimagetool already exists" 1> /dev/null
else
	echo " Downloading appimagetool..."
	wget -q https://github.com/AppImage/appimagetool/releases/download/continuous/appimagetool-x86_64.AppImage -O appimagetool
fi
chmod a+x ./appimagetool

# DOWLOAD THE DEB PACKAGE
echo " Downloading the .deb package..."
[ ! -f ./*.deb ] && wget -q "$(curl -Ls https://www.freedownloadmanager.org/download-fdm-for-linux.htm | tr '">< ' '\n' | grep "http.*deb$" | grep -vi "qt" | head -1)"

# COMPILE THE APPDIR
echo " Extracting the .deb package to the AppDir..."
mkdir -p "$APP".AppDir
ar x ./*.deb
tar fx ./data.tar*
mv ./opt/*/* "$APP".AppDir/

# Add launcher in the root of the AppDir
echo "[Desktop Entry]
Name=Free Download Manager
Comment= FDM is a powerful modern download accelerator and organizer
Keywords=download;manager;free;fdm;
Exec=$APP
Terminal=false
Type=Application
Icon=icon
Categories=Network;FileTransfer;P2P;GTK;
StartupNotify=true" > "$APP".AppDir/freedownloadmanager.desktop

# CREATE THE APPRUN
cat >> "$APP".AppDir/AppRun << 'EOF'
#!/bin/sh
HERE="$(dirname "$(readlink -f "${0}")")"
export UNION_PRELOAD="${HERE}"
exec "${HERE}"/fdm "$@"
EOF
chmod a+x "$APP".AppDir/AppRun

# EXPORT THE APP TO AN APPIMAGE
printf '#!/bin/sh\nexit 0' > ./desktop-file-validate # hack due to https://github.com/AppImage/appimagetool/pull/47
chmod a+x ./desktop-file-validate
PATH="$PATH:$PWD" ARCH=x86_64 ./appimagetool -n ./"$APP".AppDir 2>&1 | grep "Architecture\|Creating\|====\|Exportable"
if ! test -f ./*.AppImage; then
	echo "No AppImage available."; exit 1
fi
