#!/bin/sh

APP="${1#pla-install://}"
[ -z "$APP" ] && exit 1

HAVE_AM=0
HAVE_APPMAN=0
command -v am >/dev/null 2>&1 && HAVE_AM=1
command -v appman >/dev/null 2>&1 && HAVE_APPMAN=1

if [ "$HAVE_AM" -eq 0 ] && [ "$HAVE_APPMAN" -eq 0 ]; then
	echo "Error: Neither appman nor am is installed."
	read -p "Press [ENTER] to exit..."
	exit 1
fi

# Ask install scope
if command -v yad >/dev/null 2>&1; then
	yad --title="PLA Install" --text="Install <b>$APP</b>?" --button="System-Wide:0" --button="User:1"
	RET=$?
elif command -v zenity >/dev/null 2>&1; then
	zenity --question --title="PLA Install" --text="Install <b>$APP</b>?" --ok-label="System-Wide" --cancel-label="User"
	RET=$?
else
	RET=1
fi

if [ "$RET" -eq 0 ]; then
	SCOPE="system"
elif [ "$RET" -eq 1 ]; then
	SCOPE="user"
else
	exit 1
fi

# Pick CMD based on the requested scope
if [ "$SCOPE" = "system" ]; then
	if [ "$HAVE_AM" -eq 0 ]; then
		echo "Error: System-wide install requires 'am', which isn't installed."
		read -p "Press [ENTER] to exit..."
		exit 1
	fi
	CMD=am
	OPT=""
else
	if [ "$HAVE_APPMAN" -eq 1 ]; then
		CMD=appman
		OPT=""
	else
		CMD=am
		OPT="--user"
	fi
fi

echo "Running: $CMD -i $OPT \"$APP\""
$CMD -i $OPT "$APP"
echo ""
echo "Process finished."
read -p "Press [ENTER] to close this window..."