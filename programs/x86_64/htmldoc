#!/bin/sh

# AM INSTALL SCRIPT VERSION 3.5
set -u
APP=htmldoc
SITE="KurtPfeifle/htmldoc"

# CREATE DIRECTORIES AND ADD REMOVER
[ -n "$APP" ] && mkdir -p "/opt/$APP/tmp" "/opt/$APP/icons" && cd "/opt/$APP/tmp" || exit 1
printf "#!/bin/sh\nset -e\nrm -f /usr/local/bin/$APP\nrm -R -f /opt/$APP" > ../remove
printf '\n%s' "rm -f /usr/local/share/applications/$APP-AM.desktop" >> ../remove
chmod a+x ../remove || exit 1

# DOWNLOAD AND PREPARE THE APP, $version is also used for updates
version=$(curl -Ls https://api.github.com/repos/KurtPfeifle/htmldoc/releases | sed 's/[()",{} ]/\n/g' | grep -oi "https.*mage$" | grep -vi "i386|i686|aarch64|arm64|armv7l" | head -1)
wget "$version" || exit 1
#wget "$version.zsync" 2> /dev/null # Comment out this line if you want to use zsync
# Use tar fx ./*tar* here for example in this line in case a compressed file is downloaded.
cd ..
mv ./tmp/*mage ./"$APP"
mv ./tmp/*.zsync ./"$APP".zsync 2>/dev/null
rm -R -f ./tmp || exit 1
echo "$version" > ./version
chmod a+x ./"$APP" || exit 1

# LINK TO PATH
ln -s "/opt/$APP/$APP" "/usr/local/bin/$APP"

# SCRIPT TO UPDATE THE PROGRAM
cat >> ./AM-updater << 'EOF'
#!/bin/sh
set -u
APP=htmldoc
SITE="KurtPfeifle/htmldoc"
version0=$(cat "/opt/$APP/version")
version=$(curl -Ls https://api.github.com/repos/KurtPfeifle/htmldoc/releases | sed 's/[()",{} ]/\n/g' | grep -oi "https.*mage$" | grep -vi "i386|i686|aarch64|arm64|armv7l" | head -1)
[ -n "$version" ] || { echo "Error getting link"; exit 1; }
if [ "$version" != "$version0" ] || [ -e /opt/"$APP"/*.zsync ]; then
	mkdir "/opt/$APP/tmp" && cd "/opt/$APP/tmp" || exit 1
	[ -e ../*.zsync ] || notify-send "A new version of $APP is available, please wait"
	[ -e ../*.zsync ] && wget "$version.zsync" 2>/dev/null || { wget "$version" || exit 1; }
	# Use tar fx ./*tar* here for example in this line in case a compressed file is downloaded.
	cd ..
	mv ./tmp/*.zsync ./"$APP".zsync 2>/dev/null || mv --backup=t ./tmp/*mage ./"$APP"
	[ -e ./*.zsync ] && { zsync ./"$APP".zsync || notify-send -u critical "zsync failed to update $APP"; }
	chmod a+x ./"$APP" || exit 1
	echo "$version" > ./version
	rm -R -f ./*zs-old ./*.part ./tmp ./*~
	notify-send "$APP is updated!"
else
	echo "Update not needed!"
fi
EOF
chmod a+x ./AM-updater || exit 1

# LAUNCHER & ICON
./"$APP" --appimage-extract *.desktop 1>/dev/null && mv ./squashfs-root/*.desktop ./"$APP".desktop
./"$APP" --appimage-extract .DirIcon 1>/dev/null && mv ./squashfs-root/.DirIcon ./DirIcon
COUNT=0
while [ "$COUNT" -lt 10 ]; do # Tries to get the actual icon/desktop if it is a symlink to another symlink
	if [ -L ./"$APP".desktop ]; then
		LINKPATH="$(readlink ./"$APP".desktop | sed 's|^\./||' 2>/dev/null)"
		./"$APP" --appimage-extract "$LINKPATH" 1>/dev/null && mv ./squashfs-root/"$LINKPATH" ./"$APP".desktop
	fi
	if [ -L ./DirIcon ]; then
		LINKPATH="$(readlink ./DirIcon | sed 's|^\./||' 2>/dev/null)"
		./"$APP" --appimage-extract "$LINKPATH" 1>/dev/null && mv ./squashfs-root/"$LINKPATH" ./DirIcon
	fi
	[ ! -L ./"$APP".desktop ] && [ ! -L ./DirIcon ] && break
	COUNT=$((COUNT + 1))
done
sed -i "s#Exec=[^ ]*#Exec=$APP#g; s#Icon=.*#Icon=/opt/$APP/icons/$APP#g" ./"$APP".desktop
mv ./"$APP".desktop /usr/local/share/applications/"$APP"-AM.desktop && mv ./DirIcon ./icons/"$APP" 1>/dev/null
rm -R -f ./squashfs-root
