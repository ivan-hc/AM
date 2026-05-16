#!/usr/bin/env sh

# Source common test functions
. "$(dirname "$0")/test-common.sh"

# Test variables
test_results=".results.tmp"
app_name1=$(_pick_random_app "$TEST_APP_LIST_ZIP") && TEST_APP_LIST_ZIP=$(_remove_item "$TEST_APP_LIST_ZIP" "$app_name1")
app_name2=$(_pick_random_app "$TEST_APP_LIST_ZIP")

# Setup
_log "Running hide/unhide test: $0"

# Install app locally
printf "Y\n" |\
am --user
am -i "$app_name1"

# Test hide
_log "Test hide $app_name1 (local)..."
am hide "$app_name1"
am -f > "$test_results"
_check_count "$app_name1.*|" 0 "$test_results"
_test_apps "$app_name1"

# Test unhide
_log "Test unhide $app_name1 (local)..."
am unhide "$app_name1"
am -f > "$test_results"
_check_count "$app_name1.*|" 1 "$test_results"
_test_apps "$app_name1"

# Install apps in system level
am --system
am -i "$app_name1" "$app_name2"

# Test hide
_log "Test hide $app_name1..."
printf "1\n" |\
am hide "$app_name1"
am -f > "$test_results"
_check_count "$app_name1.*|" 1 "$test_results"

# Test hide for another app
_log "Test hide $app_name2..."
am hide "$app_name2"
am -f > "$test_results"
_check_count "$app_name2.*|" 0 "$test_results"
_test_apps "$app_name1 $app_name2"

# Test unhide
_log "Test unhide $app_name1..."
am unhide "$app_name1"
am -f > "$test_results"
_check_count "$app_name1.*|" 2 "$test_results"

# Test unhide for another app
_log "Test unhide $app_name2..."
am unhide "$app_name2"
am -f > "$test_results"
_check_count "$app_name2.*|" 1 "$test_results"
_test_apps "$app_name1 $app_name2"

# Pass the test
_remove_all_apps
_pass

