#!/usr/bin/env sh

# Source common test functions
. "$(dirname "$0")/test-common.sh"

# Test variables
test_results=".results.tmp"
app_name=$(_pick_random_app "$TEST_APP_LIST_ZSYNC")

# Setup
_log "Running app repair test: $0"
am --system

# Install app
_log "Installing $app_name in system mode..."
am -i "$app_name"

# Check Listing
_log "Checking if $app_name is installed and verified..."
am -f > "$test_results"
_check_count "$app_name.*\✓" 1 "$test_results"

# Corrupt app install
_log "Corrupting $app_name and checking for checksum verification failure..."
dd if=/dev/urandom bs=1 count=3 seek=8 conv=notrunc of=/opt/"$app_name"/"$app_name"
am -u "$app_name"
am -f > "$test_results"
_check_count "$app_name.*\✖" 1 "$test_results"

# Fix app install
_log "Fixing $app_name and checking for checksum verification success..."
am -u "$app_name"
am -f > "$test_results"
_check_count "$app_name.*\✓" 1 "$test_results"
_test_apps "$app_name"

# Pass the test
_remove_all_apps
_pass

