#!/bin/sh

APP=freedownloadmanager

# DOWNLOADING THE DEPENDENCIES
if test -f ./appimagetool; then
	echo " appimagetool already exists" 1> /dev/null
else
	echo " Downloading appimagetool..."
	wget -q https://github.com/AppImage/appimagetool/releases/download/continuous/appimagetool-x86_64.AppImage -O appimagetool
fi
if test -f ./pkg2appimage; then
	echo " pkg2appimage already exists" 1> /dev/null
else
	echo " Downloading pkg2appimage..."
	wget -q https://github.com/ivan-hc/AM/raw/refs/heads/main/tools/pkg2appimage -O pkg2appimage
fi
chmod a+x ./appimagetool ./pkg2appimage

# CREATING THE HEAD OF THE RECIPE
echo "app: freedownloadmanager
binpatch: true

ingredients:
  script:
    - wget -q -c \"https://dn3.freedownloadmanager.org/6/latest/freedownloadmanager.deb\"


script:
  - mv opt/freedownloadmanager/* usr/bin/
  - find . -name icon.png -exec mv {} icon.png \;
  - cat > freedownloadmanager.desktop <<EOF
  - [Desktop Entry]
  - Type=Application
  - Name=freedownloadmanager
  - Icon=icon.png
  - Exec=fdm %u
  - Categories=Network;
  - Comment=Free Download Manager
  - EOF" > recipe.yml

# DOWNLOAD ALL THE NEEDED PACKAGES AND COMPILE THE APPDIR
echo "Compilling $APP from recipe using pkg2appimage..."
./pkg2appimage ./recipe.yml >/dev/null 2>&1

# EXPORT THE APP TO AN APPIMAGE
printf '#!/bin/sh\nexit 0' > ./desktop-file-validate # hack due to https://github.com/AppImage/appimagetool/pull/47
chmod a+x ./desktop-file-validate
PATH="$PATH:$PWD" ARCH=x86_64 ./appimagetool -n ./"$APP"/"$APP".AppDir 2>&1 | grep "Architecture\|Creating\|====\|Exportable"
if ! test -f ./*.AppImage; then
	echo "No AppImage available."; exit 1
else
	rm -f ./appimagetool ./pkg2appimage
fi
