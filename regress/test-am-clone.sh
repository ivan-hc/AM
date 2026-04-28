#!/usr/bin/env sh

# Source common test functions
. "$(dirname "$0")/test-common.sh"

# Test variables
test_results=".results.tmp"
app_name1=$(_pick_random_app "$TEST_APP_LIST_ZIP")
app_name2=$(_pick_random_app "$TEST_APP_LIST_ZSYNC")
app_name3=$(_pick_random_app "$TEST_APP_LIST_NOCHK")

## Setup
_log "Running clone install list test: $0"
rm -f ~/Desktop/am-clone.source
_remove_all_apps

# Install in System Mode
_log "Installing all apps in system mode..."
am --system
am -i "$app_name1" "$app_name2" "$app_name3"

# Install in User Mode
_log "Installing all apps in user mode..."
printf "y\n" |\
am --user
am -i "$app_name1" "$app_name2" "$app_name3"

# Check listing
_log "Checking if all apps are installed in both user/system modes..."
am --system
am -f > "$test_results"
_check_count "$app_name1.*|" 2 "$test_results"
_check_count "$app_name2.*|" 2 "$test_results"
_check_count "$app_name3.*|" 2 "$test_results"

# Hide/lock apps to complicate clone process
printf "y\n" |\
am --user
am hide $app_name1
printf "y\n" |\
am lock $app_name2
am --system
printf "1\n" |\
am hide $app_name2
printf "1\ny\n" |\
am lock $app_name3

# Create cloned app list and check if it exists
_log "Create app list (am clone)..."
am clone
ls ~/Desktop > "$test_results"
_check_count "am-clone.source" 1 "$test_results"

# Remove all apps and and then reinstall them (clone previous setup)
_remove_all_apps
printf "y\n" |\
am clone install

# Check listing
_log "Checking if all apps are correctly reinstalled in both user/system modes..."
am --system
am -f > "$test_results"
_check_count "$app_name1.*|" 1 "$test_results"
_check_count "$app_name2.*|" 1 "$test_results"
_check_count "$app_name3.*|" 2 "$test_results"

# Pass the test
_remove_all_apps
_pass

