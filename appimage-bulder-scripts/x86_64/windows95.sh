#!/bin/sh

APP=windows95

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
DEB=$(curl -Ls https://api.github.com/repos/felixrieseberg/windows95/releases | sed 's/[()",{} ]/\n/g' | grep -oi "https.*" | grep -vi "i386\|i686\|aarch64\|arm64\|armv7l" | grep -i "amd64.deb" | head -1)
echo "app: $APP
binpatch: true

ingredients:

  script:
    - if ! test -f ./*.deb; then wget -q -c \"$DEB\"; fi

script:
 - rm -f windows95.png
 - wget -q https://raw.githubusercontent.com/Portable-Linux-Apps/Portable-Linux-Apps.github.io/refs/heads/main/icons/windows95.png" > recipe.yml

# DOWNLOAD ALL THE NEEDED PACKAGES AND COMPILE THE APPDIR
echo "Compilling $APP from recipe using pkg2appimage, please wait..."
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
