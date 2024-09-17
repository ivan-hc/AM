#!/bin/sh

APP=calibre

# DOWNLOADING THE DEPENDENCES
if test -f ./appimagetool; then
	echo " appimagetool already exists" 1> /dev/null
else
	echo " Downloading appimagetool..."
	wget -q "$(wget -q https://api.github.com/repos/probonopd/go-appimage/releases -O - | sed 's/"/ /g; s/ /\n/g' | grep -o 'https.*continuous.*tool.*86_64.*mage$')" -O appimagetool
fi
chmod a+x ./appimagetool

#CREATE THE APPDIR
mkdir -p "$APP".AppDir/

# DOWNLOAD THE ARCHIVE
DOWNLOAD_URL=$(curl -Ls https://api.github.com/repos/kovidgoyal/calibre/releases | sed 's/[()",{} ]/\n/g' | grep -v "i386\|i686\|aarch64\|arm64\|armv7l" | grep -i "http.*x86_64.txz$" | head -1)
if wget --version | head -1 | grep -q ' 1.'; then
	wget -q --no-verbose --show-progress --progress=bar "$DOWNLOAD_URL"
else
	wget "$DOWNLOAD_URL"
fi

# EXTRACT THE ARCHIVE
tar fx ./*txz* -C ./"$APP".AppDir/

# CREATE THE LAUNCHER
cat >> ./"$APP".AppDir/"$APP".desktop << 'EOF'
[Desktop Entry]
Categories=Office;
Comment[en_US]=E-book library management: Convert, view, share, catalogue all your e-books
Comment=E-book library management: Convert, view, share, catalogue all your e-books
Exec=AppRun
GenericName[en_US]=E-book library management
GenericName=E-book library management
Icon=calibre
MimeType=application/vnd.openxmlformats-officedocument.wordprocessingml.document;image/vnd.djvu;application/x-mobi8-ebook;application/x-cbr;text/fb2+xml;application/pdf;application/x-cbc;application/vnd.ms-word.document.macroenabled.12;text/rtf;application/epub+zip;application/x-cbz;text/plain;application/x-sony-bbeb;application/oebps-package+xml;application/x-cb7;application/x-mobipocket-ebook;application/ereader;text/html;text/x-markdown;application/xhtml+xml;application/vnd.oasis.opendocument.text;application/x-mobipocket-subscription;x-scheme-handler/calibre;
Name=calibre
Type=Application
X-DBUS-ServiceName=
X-DBUS-StartupType=
X-KDE-SubstituteUID=false
X-KDE-Username=
EOF

# ADD THE ICON AT THE ROOT OF THA APPDIR
cp ./"$APP".AppDir/resources/content-server/calibre.png ./"$APP".AppDir/calibre.png

# CREATE THE APPRUN
cat >> ./"$APP".AppDir/AppRun << 'EOF'
#!/bin/sh
HERE="$(dirname "$(readlink -f "${0}")")"
exec "${HERE}"/calibre "$@"
EOF
chmod a+x ./"$APP".AppDir/AppRun

# CONVERT THE APPDIR TO AN APPIMAGE
echo "\nConverting the AppDir to an AppImage...\n"
ARCH=x86_64 VERSION=$(./appimagetool -v | grep -o '[[:digit:]]*') ./appimagetool -s ./"$APP".AppDir 2>&1 | grep "Architecture\|Creating\|====\|Exportable"
