#!/bin/sh

APP=SAMPLE
APPNAME=APPIMAGENAME

CATEGORIES=$(curl -L -s https://raw.githubusercontent.com/AppImage/appimage.github.io/master/apps/$APPNAME.md | grep -E -i categories | cut -c 17-)
ICONURL="https://appimage.github.io/database/$(curl -L -s https://raw.githubusercontent.com/AppImage/appimage.github.io/master/apps/$APPNAME.md | grep -E -i icons | sed -n 2p | cut -c 5-)"
REPO=$(curl -L -s https://raw.githubusercontent.com/AppImage/appimage.github.io/master/apps/$APPNAME.md | grep -A1 "type: GitHub" | sed -n 2p | cut -c 10-)
USER=$(echo $REPO | sed 's:/[^/]*$::')
REPO2=$(echo $REPO | sed 's:.*/::')
FILENAMEEXTENTION="/.*/.*.*mage"
URL=https://github.com/$REPO/releases/latest
COMMENT=$(curl -L -s https://raw.githubusercontent.com/AppImage/appimage.github.io/master/apps/$APPNAME.md | grep "Comment:" | cut -c 14-)

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

download=$(curl -Ls https://api.github.com/repos/$REPO/releases/latest | jq '.' | grep -E browser_download_url | awk -F '[""]' '{print $4}' | grep -w -v i386 | grep -w -v i686 | grep -w -v arm64 | grep -w -v armv7l | egrep ''$FILENAMEEXTENTION'' -o | head -1);
wget https:$download

version=$(curl -Ls https://api.github.com/repos/$REPO/releases/latest | jq '.' | grep -E tag_name | awk -F '[""]' '{print $4}')
echo "$version" >> /opt/$APP/version

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
APPNAME=APPIMAGENAME
REPO=$(curl -L -s https://raw.githubusercontent.com/AppImage/appimage.github.io/master/apps/$APPNAME.md | grep -A1 "type: GitHub" | sed -n 2p | cut -c 10-)
version0=$(cat /opt/$APP/version)
url=https://github.com/FUNCTION2/FUNCTION3/releases/latest
if curl -L -s $url | grep -ioF "$version0"; then
  echo "Update not needed!"
else
  notify-send "A new version of $APP is available, please wait"
  mkdir /opt/$APP/tmp
  cd /opt/$APP/tmp
  URL=https://github.com/FUNCTION2/FUNCTION3/releases/latest
  wget https://github.com/$(wget https://github.com/FUNCTION2/FUNCTION3/releases/latest -O - | grep -w -v i386 | grep -w -v i686 | grep -w -v arm64 | grep -w -v armv7l | egrep ''FUNCTION4'' -o | head -1);
  wget https:$download
  version=$(curl -Ls https://api.github.com/repos/FUNCTION2/FUNCTION3/releases/latest | jq '.' | grep -E tag_name | awk -F '[""]' '{print $4}')
  cd ..
  if test -f ./tmp/*mage; then rm ./version
  fi
  echo $version >> ./version
  mv --backup=t ./tmp/*mage ./$APP
  chmod a+x /opt/$APP/$APP
  rm -R -f ./tmp ./*~
  notify-send "$APP is updated!"
fi
EOF
sed -i s/FUNCTION2/$USER/g /opt/$APP/AM-updater
sed -i s/FUNCTION3/$REPO2/g /opt/$APP/AM-updater
sed -i s/FUNCTION4/$FILENAMEEXTENTION/g /opt/$APP/AM-updater
chmod a+x /opt/$APP/AM-updater

# LAUNCHER
rm /usr/share/applications/AM-$APP.desktop
wget $(curl -Ls https://api.github.com/repos/AppImage/appimage.github.io/contents/database/$APPNAME/ | jq '.' | grep download_url | head -1 | cut -c 22- | rev | cut -c 3- | rev) -O $APP.desktopapp=$(echo $APP | cut -c -3)
CHANGEEXEC=$(cat ./$APP.desktop | grep Exec= | tr ' ' '\n' | tr '=' '\n' | tr '/' '\n' | grep $app | head -1)
sed -i "s#$CHANGEEXEC#$APP#g" ./$APP.desktop
sed -i "s#AppRun#$APP#g" ./$APP.desktop
sed -i "s#Exec=/bin/#Exec=#g" ./$APP.desktop
sed -i "s#Exec=/usr/bin/#Exec=#g" ./$APP.desktop
CHANGEICON=$(cat ./$APP.desktop | grep Icon= | head -1)
sed -i "s#$CHANGEICON#Icon=/opt/$APP/icons/$APP#g" ./$APP.desktop
mv ./$APP.desktop /usr/share/applications/AM-$APP.desktop

# ICON
mkdir ./icons
wget $ICONURL -O /opt/$APP/icons/$APP
