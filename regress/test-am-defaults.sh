#!/usr/bin/env sh

# Source common test functions
. "$(dirname "$0")/test-common.sh"

# Test variables
test_results=".results.tmp"
app_name1=$(_pick_random_app "$TEST_APP_LIST_ZIP") && TEST_APP_LIST_ZIP=$(_remove_item "$TEST_APP_LIST_ZIP" "$app_name1")
app_name2=$(_pick_random_app "$TEST_APP_LIST_ZIP")

# Setup
_log "Running auto-yes defaults test: $0"

# Install app locally
am -y --user
am -i "$app_name1" "$app_name2"

# Test lock/unlock
_log "Test lock $app_name1 (auto-yes)..."
am -y lock "$app_name1" > "$test_results"
_check_count "$app_name1.*locked" 1 "$test_results"
_log "Test unlock $app_name1 (auto-yes)..."
am -y unlock "$app_name1" > "$test_results"
_check_count "$app_name1.*receive updates" 1 "$test_results"

# Install apps in system level
am --system
am -i "$app_name1" "$app_name2"

# Test hide
_log "Test hide $app_name1 (select option 1. automatically)..."
am -y hide "$app_name1"
am -f > "$test_results"
_check_count "$app_name1.*|" 1 "$test_results"

# Test unhide
_log "Test unhide $app_name1..."
am unhide "$app_name1"
am -f > "$test_results"
_check_count "$app_name1.*|" 2 "$test_results"

# Test translate
_log "Test translate (select en automatically)..."
am -y translate > "$test_results"
_check_count "Setting locale.*\"en" 1 "$test_results"

# Test removal
_log "Test removal (select option 1. automatically)..."
am -y -r "$app_name1" "$app_name2"
am --system
_log "Test removal (auto-yes)..."
am -y -r "$app_name1" "$app_name2"
am -f > "$test_results"
_check_count "$app_name1.*|" 0 "$test_results"
_check_count "$app_name2.*|" 0 "$test_results"

# Pass the test
_remove_all_apps
_pass

