#!/bin/sh

APP=SAMPLE

# LET TAKE INFO FROM APPIMAGE.GITHUB.IO
APPNAME=APPIMAGENAME
CATEGORIES=$(curl -L -s https://raw.githubusercontent.com/AppImage/appimage.github.io/master/apps/$APPNAME.md | grep -E -i categories | cut -c 17-)
ICONURL="https://appimage.github.io/database/$(curl -L -s https://raw.githubusercontent.com/AppImage/appimage.github.io/master/apps/$APPNAME.md | grep -E -i icons | sed -n 2p | cut -c 5-)"
COMMENT=$(curl -L -s https://raw.githubusercontent.com/AppImage/appimage.github.io/master/apps/$APPNAME.md | grep "Comment:" | cut -c 14-)

# WEBSITESITE
URL0="MAINSITE"
# WHERE TO CHECK THE DOWNLOAD LINK
URL1="SOMEWHEREURL"
URL2="AppImage"

# CREATE THE FOLDER
mkdir /opt/$APP
cd /opt/$APP

# ADD THE REMOVER
echo '#!/bin/sh' >> /opt/$APP/remove
echo "rm -R -f /usr/share/applications/AM-$APP.desktop /opt/$APP /usr/local/bin/$APP" >> /opt/$APP/remove
chmod a+x /opt/$APP/remove

# DOWNLOAD THE APPIMAGE
mkdir tmp
cd ./tmp

version=$(wget -q $URL1 -O - | grep -Eo "(http|https)://[a-zA-Z0-9./?=_%:-]*" | grep "$URL2" | head -1)
wget $version
echo $version >> /opt/$APP/version

cd ..
mv ./tmp/*mage ./$APP
chmod a+x /opt/$APP/$APP
rmdir ./tmp

# LINK
ln -s /opt/$APP/$APP /usr/local/bin/$APP

# SCRIPT TO UPDATE THE PROGRAM
cat >> /opt/$APP/AM-updater << 'EOF'
#!/usr/bin/env bash
APP=SAMPLE
version0=$(cat /opt/$APP/version)
url=FUNCTION1
if curl -L -s $url | grep -ioF "$version0"; then
  echo "Update not needed!"
else
  notify-send "A new version of $APP is available, please wait"
  mkdir /opt/$APP/tmp
  cd /opt/$APP/tmp
  version=$(wget -q $url -O - | grep -Eo "(http|https)://[a-zA-Z0-9./?=_%:-]*" | grep "FUNCTION2" | head -1)
  wget $version
  cd ..
  if test -f ./tmp/*mage; then rm ./version
  fi
  echo $version >> ./version
  mv --backup=t ./tmp/*mage ./$APP
  chmod a+x /opt/$APP/$APP
  rm -R -f ./tmp ./*~
fi
EOF
sed -i s@FUNCTION1@$URL1@g /opt/$APP/AM-updater
sed -i s@FUNCTION2@$URL2@g /opt/$APP/AM-updater
chmod a+x /opt/$APP/AM-updater

# LAUNCHER & ICON
cd /opt/$APP
mv $(./$APP --appimage-extract *.desktop) ./$APP.desktop
if desktop-file-validate --no-hints ./$APP.desktop | grep error; then rm ./$APP.desktop; mv $(./$APP --appimage-extract usr/share/applications/*$APP*.desktop) ./$APP.desktop; fi
if [ ! -e ./$APP.desktop ]; then rm ./$APP.desktop; mv $(/opt/$APP/$APP --appimage-extract usr/share/applications/*.desktop) ./$APP.desktop; fi
if [ ! -e ./$APP.desktop ]; then rm ./$APP.desktop; mv $(/opt/$APP/$APP --appimage-extract share/applications/*.desktop) ./$APP.desktop; fi
if cat ./$APP.desktop | grep Exec | grep AppRun; then rm ./$APP.desktop; mv $(./$APP --appimage-extract usr/share/applications/*$APP*.desktop) ./$APP.desktop; fi
CHANGEEXEC=$(cat ./$APP.desktop | grep Exec= | tr ' ' '\n' | tr '=' '\n' | tr '/' '\n' | grep $APP | head -1)
sed -i "s#$CHANGEEXEC#$APP#g" ./$APP.desktop
CHANGEICON=$(cat ./$APP.desktop | grep Icon= | grep $APP | head -1)
sed -i "s#$CHANGEICON#Icon=/opt/$APP/icons/$APP#g" ./$APP.desktop

mkdir icons
mv $(./$APP --appimage-extract *.png) ./icons/$APP 2>/dev/null
mv $(./$APP --appimage-extract *.svg) ./icons/$APP 2>/dev/null
mv $(./$APP --appimage-extract share/icons/hicolor/22x22/apps/*$APP*) ./icons/$APP 2>/dev/null
mv $(./$APP --appimage-extract share/icons/hicolor/24x24/apps/*$APP*) ./icons/$APP 2>/dev/null
mv $(./$APP --appimage-extract share/icons/hicolor/32x32/apps/*$APP*) ./icons/$APP 2>/dev/null
mv $(./$APP --appimage-extract share/icons/hicolor/48x48/apps/*$APP*) ./icons/$APP 2>/dev/null
mv $(./$APP --appimage-extract share/icons/hicolor/64x64/apps/*$APP*) ./icons/$APP 2>/dev/null
mv $(./$APP --appimage-extract share/icons/hicolor/128x128/apps/*$APP*) ./icons/$APP 2>/dev/null
mv $(./$APP --appimage-extract share/icons/hicolor/256x256/apps/*$APP*) ./icons/$APP 2>/dev/null
mv $(./$APP --appimage-extract share/icons/hicolor/512x512/apps/*$APP*) ./icons/$APP 2>/dev/null
mv $(./$APP --appimage-extract share/icons/hicolor/scalable/apps/*$APP*) ./icons/$APP 2>/dev/null
mv $(./$APP --appimage-extract usr/share/icons/hicolor/22x22/apps/*$APP*) ./icons/$APP 2>/dev/null
mv $(./$APP --appimage-extract usr/share/icons/hicolor/24x24/apps/*$APP*) ./icons/$APP 2>/dev/null
mv $(./$APP --appimage-extract usr/share/icons/hicolor/32x32/apps/*$APP*) ./icons/$APP 2>/dev/null
mv $(./$APP --appimage-extract usr/share/icons/hicolor/48x48/apps/*$APP*) ./icons/$APP 2>/dev/null
mv $(./$APP --appimage-extract usr/share/icons/hicolor/64x64/apps/*$APP*) ./icons/$APP 2>/dev/null
mv $(./$APP --appimage-extract usr/share/icons/hicolor/128x128/apps/*$APP*) ./icons/$APP 2>/dev/null
mv $(./$APP --appimage-extract usr/share/icons/hicolor/256x256/apps/*$APP*) ./icons/$APP 2>/dev/null
mv $(./$APP --appimage-extract usr/share/icons/hicolor/512x512/apps/*$APP*) ./icons/$APP 2>/dev/null
mv $(./$APP --appimage-extract usr/share/icons/hicolor/scalable/apps/*$APP*) ./icons/$APP 2>/dev/null

rm -R -f /opt/$APP/squashfs-root
mv ./$APP.desktop /usr/share/applications/AM-$APP.desktop

# CHANGE THE PERMISSIONS
currentuser=$(who | awk '{print $1}')
chown -R $currentuser /opt/$APP

# MESSAGE
echo '

 '$APPNAME' is provided by '$URL0'

'
