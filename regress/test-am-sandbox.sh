#!/usr/bin/env sh

# Source common test functions
. "$(dirname "$0")/test-common.sh"

# Test variables
test_results=".results.tmp"

# Setup
_log "Running sandbox test: $0"
mkdir -p ~/Desktop/test_dir
mkdir -p ~/Documents/test_dir
am --system

# Install sandbox tool
am -i aisap

# Install and sandbox a simple appimage command line tool
_log "Sandboxing app (access to only ~/Desktop)..."
am -R bench-cli
printf "Y\nY\nN\nN\nN\nN\nN\nN\nN\n" |\
am -ias bench-cli

# Test directory access
_log "Test app access to ~/Desktop..."
bench-cli ls ~/Desktop > "$test_results"
_check_count "test_dir" 1 "$test_results"
_log "Test app access to ~/Documents..."
bench-cli ls ~/Documents > "$test_results"
_check_count "test_dir" 0 "$test_results"

# Unsandbox appimage
_log "Unsandbox app..."
am --disable-sandbox bench-cli

# Remove libfuse2 dependency
_log "Removing libfuse2 dependency..."
printf "Y\n" |\
am nolibfuse bench-cli

# Test directory access
_log "Test app access to ~/Desktop..."
bench-cli ls ~/Desktop > "$test_results"
_check_count "test_dir" 1 "$test_results"
_log "Test app access to ~/Documents..."
bench-cli ls ~/Documents > "$test_results"
_check_count "test_dir" 1 "$test_results"

# Pass the test
_remove_all_apps
_pass

