#!/usr/bin/env sh

# Source common test functions
. "$(dirname "$0")/test-common.sh"

# Test variables
test_results=".results.tmp"
app_name=$(_pick_random_app "$TEST_APP_LIST_ZIP")
app_name_old=$(_pick_random_app "$TEST_APP_LIST_OLD")

# Setup
_log "Running multi-user install test: $0"
am --system

# Install in System Mode
_log "Installing $app_name in system mode..."
am -i "$app_name"
_test_apps "$app_name"

# Install in User Mode
_log "Installing $app_name in user mode..."
printf "Y\n" |\
am --user
am -i "$app_name"
_test_apps "$app_name"

# Check Listing
_log "Checking if $app_name is installed in both user/system modes..."
am --system
am -f > "$test_results"
_check_count "$app_name.*|" 2 "$test_results"

# Remove in User Mode
_log "Removing $app_name in user mode..."
printf "Y\n" |\
am --user
printf "Y\n" |\
am -r "$app_name"

# Check for Errors
_log "Checking if $app_name is removed in user mode..."
am -f > "$test_results"
_check_count "$app_name.*|" 0 "$test_results"

# Reinstall in User Mode
_log "Installing $app_name in user mode again..."
am -i "$app_name"
_test_apps "$app_name"

# Remove in System Mode and User Mode (option 2)
_log "Removing $app_name in user & system mode..."
am --system
printf "2\n" |\
am -r "$app_name"
am -R "$app_name"

# Check for Errors
_log "Checking if $app_name is completely removed in system mode..."
am -f > "$test_results"
_check_count "$app_name.*|" 0 "$test_results"

# Install old app in both modes
_log "Installing $app_name_old (outdated) in both system/user modes..."
am -i "$app_name_old"
am -i --user "$app_name_old"
_test_apps "$app_name_old"

# Check for "old release msg"
_log "Checking if $app_name_old (outdated) is listed in both system/user modes with warnings..."
am -f > "$test_results"
_check_count "$app_name_old" 4 "$test_results"

# Pass the test
_remove_all_apps
_pass

