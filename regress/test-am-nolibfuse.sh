#!/usr/bin/env sh

# Source common test functions
. "$(dirname "$0")/test-common.sh"

# Test variables
test_results=".results.tmp"
app_name="bench-cli"

# Setup
_log "Running libfuse2 removal test: $0"
_hide_libfuse2
am --system

# Install a known archived command line tool that uses libfuse2
_log "Installing a known libfuse2 app..."
am -R "$app_name"
am -i "$app_name"

# Test app
_log "Testing app to see libfuse2 error..."
"$app_name" 2> "$test_results"
_check_count "error.*libfuse" 1 "$test_results"

# Remove libfuse2 dependency
_log "Removing libfuse2 dependency..."
printf "Y\n" |\
am nolibfuse "$app_name"

# Test app
_log "Testing app to see if libfuse2 error is gone..."
"$app_name" 2> "$test_results"
_check_count "error.*libfuse" 0 "$test_results"

# Pass the test
_restore_libfuse2
_remove_all_apps
_pass

