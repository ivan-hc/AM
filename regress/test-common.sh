#!/usr/bin/env sh

# Test logfile
TEST_LOG="test-summary.log"

# List of test apps (REQUIREMENTS: Under 20MB, has .zsync, simple install script)
TEST_APP_LIST_ZSYNC="zsync2 xeyes rofi foot pavucontrol-qt"

# List of test apps with DIGEST files (REQUIREMENTS: Under 20MB, a digest file, simple install script)
TEST_APP_LIST_DIG="keepassxc"

# List of test apps that are zipped (REQUIREMENTS: Under 10MB, no .zsync, simple install script)
TEST_APP_LIST_ZIP="clifm cheat dra nyan navi lsd hyperfine fcp"

# List of test apps that cant be verified (REQUIREMENTS: Under 10MB, no .zsync/digest, not zipped, simple install script)
TEST_APP_LIST_NOCHK="bench-cli helio appimagen appimageupdate crabfetch"

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

	# Output both picked item and new list
	echo "$new_list"
}

# Message log function
_log() {
	echo "\033[1;34m$1\033[0m"
	echo "$1" >> "$TEST_LOG"
}

# Test fail log function
_fail() {
	echo "\033[0;31m$1\033[0m\n"
	echo "$1" >> "$TEST_LOG"
	echo "Test failed!\n" >> "$TEST_LOG"
	exit 1
}

# Test pass log function
_pass() {
	PASS_MSG="Test passed!"
	echo "\033[0;32m$PASS_MSG\033[0m\n"
	echo "$PASS_MSG\n" >> "$TEST_LOG"
	exit 0
}

# Function to remove all apps
_remove_all_apps() {
	# Remove system apps
	apps=$(ls /opt/ | xargs)
	for a in $apps; do
		if [ "$a" != am ]; then
			/opt/"$a"/remove
		fi
	done

	# Remove local apps
	apps=$(ls /root/Applications/ | xargs)
	for a in $apps; do
		/root/Applications/"$a"/remove
	done
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

