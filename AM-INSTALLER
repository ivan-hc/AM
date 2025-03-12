#!/bin/sh

set -e

# Colors
RED='\033[0;31m'; LightBlue='\033[1;34m'; Green='\033[0;32m'

# For developers
AM_BRANCH="main"

# Check dependencies for this script
_check_dependency() {
	AMDEPENDENCES="chmod chown curl grep wget"
	for dependency in $AMDEPENDENCES; do
		if ! command -v "$dependency" >/dev/null 2>&1; then
			printf "\n %b💀 ERROR! MISSING ESSENTIAL COMMAND \033[0m: %b\n\n Install the above and try again! \n\n" "${RED}" "$dependency"
			exit 1
		fi
	done
}

_check_dependency

# Function to check online connections (uses github.com by default, as the database and CLI itself are stored/hosted there)
_online_check() {
	if ! wget -q --tries=3 --timeout=10 --spider https://github.com; then
		printf "\n Installer wouldn't work offline\n\n Please check your internet connection and try again\n\n"
		exit 1
	fi
}

_online_check

# INSTALL "AM" SYSTEM-WIDE
_install_am() {
	CACHEDIR="${XDG_CACHE_HOME:-$HOME/.cache}"
	mkdir -p "$CACHEDIR" || true
	rm -f "$CACHEDIR"/INSTALL-AM.sh || true
	wget -q "https://raw.githubusercontent.com/ivan-hc/AM/$AM_BRANCH/INSTALL" -O "$CACHEDIR"/INSTALL-AM.sh && chmod a+x "$CACHEDIR"/INSTALL-AM.sh
	#cp ./INSTALL "$CACHEDIR"/INSTALL-AM.sh && chmod a+x "$CACHEDIR"/INSTALL-AM.sh # for developers
	if command -v sudo >/dev/null 2>&1; then
		SUDOCMD="sudo"
	elif command -v doas >/dev/null 2>&1; then
		SUDOCMD="doas"
	else
		echo 'ERROR: No sudo or doas found'
		exit 1
	fi
	$SUDOCMD "$CACHEDIR"/INSTALL-AM.sh && rm -f "$CACHEDIR"/INSTALL-AM.sh
}

# INSTALL "AM" LOCALLY, AS "APPMAN"
_install_appman() {
	ZSHRC="${ZDOTDIR:-$HOME}/.zshrc"
	BINDIR="${XDG_BIN_HOME:-$HOME/.local/bin}"
	mkdir -p "$BINDIR"
	if ! echo $PATH | grep "$BINDIR" >/dev/null 2>&1; then 
		echo '--------------------------------------------------------------------------'
		echo " Adding $BINDIR to PATH, you might need to"
		echo " close and reopen the terminal for this to take effect."
		if [ -e ~/.bashrc ] && ! grep 'PATH="$PATH:$BINDIR"' ~/.bashrc >/dev/null 2>&1; then
			printf '\n%s\n' 'BINDIR="${XDG_BIN_HOME:-$HOME/.local/bin}"' >> ~/.bashrc
			printf '\n%s\n' 'if ! echo $PATH | grep "$BINDIR" >/dev/null 2>&1; then' >> ~/.bashrc
			printf '	export PATH="$PATH:$BINDIR"\nfi\n' >> ~/.bashrc
		fi
		if [ -e "$ZSHRC" ] && ! grep 'PATH="$PATH:$BINDIR"' "$ZSHRC" >/dev/null 2>&1; then
			printf '\n%s\n' 'BINDIR="${XDG_BIN_HOME:-$HOME/.local/bin}"' >> "$ZSHRC"
			printf '\n%s\n' 'if ! echo $PATH | grep "$BINDIR" >/dev/null 2>&1; then' >> "$ZSHRC"
			printf '	export PATH="$PATH:$BINDIR"\nfi\n' >> "$ZSHRC"
		fi
	fi
	wget -q "https://raw.githubusercontent.com/ivan-hc/AM/$AM_BRANCH/APP-MANAGER" -O "$BINDIR"/appman && chmod a+x "$BINDIR"/appman
}

# CHOOSE BETWEEN "AM" AND "APPMAN"
printf " Choose how to install \"AM\" and all its managed applications.

 1) As \"${RED}AM\033[0m\", command \"${Green}am\033[0m\", this is a system-wide installation:
   - the command is a symlink /usr/local/bin/am for /opt/am/APP-MANAGER
   - install and manage both system (default, require \"root\") and local apps
   - choose wherever you want to install local apps
   - you are the one with read-write permissions for \"AM\" and system programs
   - other users can only use programs you have installed, nothing else
   - other users can still use \"AppMan mode\" for their rootless configurations

 2) As \"${LightBlue}AppMan\033[0m\", command \"${Green}appman\033[0m\", local installation:
   - the command is the script ~/.local/bin/appman
   - install and manage only local apps
   - choose wherever you want to install local apps
   - you can replicate your configurations on every system you want
   - more storage space required, if more users use \"AppMan\"

"
read -r -p "Choose between \"AM\" (type 1) and \"AppMan\" (2), or leave blank to exit: " response
case "$response" in
	1)	_install_am || exit 1
		;;
	2)	_install_appman || exit 1
		echo '--------------------------------------------------------------------------'
		printf " ${Green}\"AppMan\" has been successfully installed!\033[0m\n"
		printf " Please, run \"${LightBlue}appman -h\033[0m\" to see the list of the options.\n"
		echo '--------------------------------------------------------------------------'
		;;
	''|*)	echo "Installation aborted, exiting." && exit 1
		;;
esac
