#!/usr/bin/env sh

# Source common test functions
. "$(dirname "$0")/test-common.sh"

# Test variables
test_results=".results.tmp"
app_name1=$(_pick_random_app "$TEST_APP_LIST_ZSYNC") && TEST_APP_LIST_ZSYNC=$(_remove_item "$TEST_APP_LIST_ZSYNC" "$app_name1")
app_name2=$(_pick_random_app "$TEST_APP_LIST_ZSYNC")
app_name_digest=$(_pick_random_app "$TEST_APP_LIST_DIG")
app_name_zip=$(_pick_random_app "$TEST_APP_LIST_ZIP")
app_name_nochk=$(_pick_random_app "$TEST_APP_LIST_NOCHK")

# Setup
_log "Running checksum test: $0"
am --system

# Remove all apps first
am -R "$app_name1" "$app_name2" "$app_name_digest" "$app_name_zip" "$app_name_nochk"

# Test install
am -i "$app_name1" > "$test_results"
_check_count "checksum verified" 1 "$test_results"

# Test install for another app
am -i "$app_name2" > "$test_results"
_check_count "checksum verified" 1 "$test_results"

# Test install for app with digest files
am -i "$app_name_digest" > "$test_results"
_check_count "checksum verified" 1 "$test_results"

# Test install for app that are tarballs/zip files
am -i "$app_name_zip" > "$test_results"
_check_count "checksum auto-verified" 1 "$test_results"

# Test install for app with no zsync files (checksum wont be verified)
am -i "$app_name_nochk" > "$test_results"
_check_count "checksum verified" 0 "$test_results"

# Check if apps were installed correctly
_test_apps "$app_name1 $app_name2 $app_name_digest $app_name_zip $app_name_nochk"

# Pass the test
_remove_all_apps
_pass

