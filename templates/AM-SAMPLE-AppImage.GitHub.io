#!/bin/sh

APP=SAMPLE
APPNAME=NAME #Required for the icon and the launcher, when programs on appimage.github.io are named with capital letters

# CREATE THE FOLDER
mkdir /opt/$APP
cd /opt/$APP

# ADD THE REMOVER
echo '#!/bin/sh' >> /opt/$APP/remove
echo "rm -R -f /usr/share/applications/AM-$APP.desktop /opt/$APP /usr/local/bin/$APP" >> /opt/$APP/remove
chmod a+x /opt/$APP/remove

# DOWNLOAD THE PROGRAM
mkdir ./tmp
cd ./tmp
wget https://raw.githubusercontent.com/ivan-hc/AM-Application-Manager/main/tools/upp
chmod a+x ./upp
./upp install $APP
cd ..
version=$(cd /opt/$APP/tmp && ls -1 *mage)
echo $version >> ./version
mv ./tmp/*mage ./$APP
rm -R -f ./tmp

# LINK
ln -s /opt/$APP/$APP /usr/local/bin/$APP

# SCRIPT TO UPDATE THE PROGRAM
echo '#!/usr/bin/env bash
notify-send "Download in progress, please wait!"
mkdir /opt/'$APP'/tmp
cd /opt/'$APP'/tmp
wget https://raw.githubusercontent.com/ivan-hc/AM-Application-Manager/main/tools/upp
chmod a+x ./upp
./upp install '$APP'
cd ..
rm /opt/'$APP'/version
version=$(cd /opt/'$APP'/tmp && ls -1 *mage)
echo $version >> ./version
mv ./tmp/*mage ./'$APP'
rm -R -f ./tmp' >> /opt/$APP/AM-updater
chmod a+x /opt/$APP/AM-updater

# LAUNCHER
wget https://appimage.github.io/database/$APPNAME/$APP.desktop -O AM-$APP.desktop
sed -i "s#Icon=#Icon=/opt/$APP/icons/#g" ./AM-$APP.desktop
sed -i "s#$APP.wrapper#$APP#g" ./AM-$APP.desktop
mv /opt/$APP/AM-$APP.desktop /usr/share/applications/AM-$APP.desktop

# ICON
mkdir ./icons
wget https://appimage.github.io/database/$APPNAME/icons/128x128/$APP.png -O /opt/$APP/icons/$APP

# CHANGE THE PERMISSIONS
currentuser=$(who | awk '{print $1}')
chown -R $currentuser /opt/$APP

# MESSAGE
echo "

 MESSAGE
  
";
