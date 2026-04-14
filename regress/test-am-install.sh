#!/usr/bin/env sh

# Source common test functions
. "$(dirname "$0")/test-common.sh"

# Test variables
test_results=".results.tmp"
app_name=$(_pick_random_app "$TEST_APP_LIST_ZIP")

# Install in System Mode
_log "Installing $app_name in system mode..."
am --system
am -i "$app_name"

# Install in User Mode
_log "Installing $app_name in user mode..."
am --user
am -i "$app_name"

# Check Listing
_log "Checking if $app_name is installed in both user/system modes..."
am --system
am -f > "$test_results"
_check_count "$app_name" 2 "$test_results"

# Remove in User Mode
_log "Removing $app_name in user mode..."
am --user
am -r "$app_name"

# Check for Errors
_log "Checking if $app_name is removed from user mode..."
am -f > "$test_results"
_check_count "$app_name" 0 "$test_results"

# Remove in System Mode
_log "Removing $app_name in system mode..."
am --system
am -r "$app_name"

# Check for Errors
_log "Checking if $app_name is removed from system mode..."
am -f > "$test_results"
_check_count "$app_name" 0 "$test_results"

# Clean up test results file
rm -f "$test_results"

# Pass the test if all was good
_log "Test passed!"

