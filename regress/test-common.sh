#!/usr/bin/env sh

# Test logfile
TEST_LOG="test-summary.log"

# List of test apps with zsync files (REQUIREMENTS: Under 20MB, has .zsync, simple install script)
TEST_APP_LIST_ZSYNC="zsync2 xeyes rofi sas aisap clagrange"

# List of test apps with only digest files (REQUIREMENTS: Under 20MB, a digest file, simple install script)
TEST_APP_LIST_DIG="conky" #Too big: joplin dinox

# List of test apps that are zipped (REQUIREMENTS: Under 10MB, no .zsync, simple install script)
TEST_APP_LIST_ZIP="clifm gotimer dra nyan navi lsd hyperfine fcp"

# List of test apps that cant be verified (REQUIREMENTS: Under 10MB, no .zsync/digest, not zipped, simple install script)
TEST_APP_LIST_NOCHK="bench-cli helio appimagen crabfetch colorstatic-bash"

# List of test apps that are outdated (REQUIREMENTS: Under 10MB, simple install script)
TEST_APP_LIST_OLD="aisap bench-cli colorstatic-bash"

# List of test apps that can be downgraded (REQUIREMENTS: Under 5MB, simple install script)
TEST_APP_LIST_DOWN="clifm aisap fcp zsync2"

# Function to randomly pick an app from a list
_pick_random_app() {
	# Get count
	list_lines=$(echo "$1" | tr ' ' '\n' | sed '/^\s*$/d') # Convert to vertical list and remove empty lines
	count=$(echo "$list_lines" | wc -l)

	# Check if list is empty
	if [ "$count" -eq 0 ]; then
		return 1
	fi

	# Pick a random app
	random_index=$(($(od -An -N2 -tu2 /dev/urandom | tr -d ' ') % count + 1))
	picked=$(echo "$list_lines" | sed -n "${random_index}p")

	# Output both picked item and new list
	echo "$picked"
}

# Function to remove an app from a list
_remove_item() {
	#Variables
	list="$1"
	item_to_remove="$2"
	new_list=""

	# Iterate and remove item
	for item in $list; do
		if [ "$item" != "$item_to_remove" ]; then
			new_list="$new_list $item"
		fi
	done

	# Output new list with item removed
	echo "$new_list"
}

# Message log function
_log() {
	printf "\033[1;34m%b\033[0m\n" "$1"
	printf "%b\n" "$1" >> "$TEST_LOG"
}

# Test fail log function
_fail() {
	printf "\033[0;31m%b\033[0m\n" "$1"
	printf "%b\n" "$1" >> "$TEST_LOG"
	printf "%s\n\n" "Test failed!" >> "$TEST_LOG"
	exit 1
}

# Test pass log function
_pass() {
	PASS_MSG="Test passed!"
	printf "\033[0;32m%s\033[0m\n\n" "$PASS_MSG"
	printf "%s\n\n" "$PASS_MSG" >> "$TEST_LOG"
	exit 0
}

# Function to remove all AM apps
_remove_all_apps() {
	# Remove AM local apps
	printf "y\n" | am --user
	apps=$(ls ~/Applications/ | xargs)
	for a in $apps; do
		am unhide "$a"
		~/Applications/"$a"/remove
	done

	# Remove AM system apps
	am --system
	apps=$(ls /opt/ | xargs)
	for a in $apps; do
		if [ "$a" != am ]; then
			am unhide "$a"
			/opt/"$a"/remove
		fi
	done

	# Clean up symlinks
	rm -rf ~/.local/bin/*
	rm -rf /usr/local/bin/*
	ln -s /opt/am/APP-MANAGER /usr/local/bin/am

	# Check if number of apps is as expected
	if [ "$(am -f --less | sed -n 1p)" != "1" ]; then
		_fail "Error: Unable to fully remove AM system apps."
	fi
	if [ "$(am -f --less | sed -n 3p)" != "0" ]; then
		_fail "Error: Unable to fully remove AM local apps."
	fi
}

# Function to get app info from am -f table collumns
_get_app_info() {
	app_name="$1"
	info_collumn="$2"
	app_info=$(am -f | grep "$app_name" | cut -d'|' -f"$info_collumn" | head -n 1)
	echo "$app_info"
}

# Function to check the count of a specific message/text in the results
_check_count() {
	chk_msg_name="$1"
	chk_expected_count="$2"
	chk_file="$3"
	chk_actual_count=$(grep -ic "$chk_msg_name" "$chk_file")

	# Check msg count
	if [ "$chk_actual_count" -ne "$chk_expected_count" ]; then
		_fail "Error: \"$chk_msg_name\" should occur $chk_expected_count times, but was found $chk_actual_count times."
	fi
}

