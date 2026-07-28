#!/usr/bin/env sh

# Source common test functions
. "$(dirname "$0")/test-common.sh"

# Test variables
test_results=".results.tmp"
app_name=$(_pick_random_app "$TEST_APP_LIST_DESK")
desktop_file1=/usr/local/share/applications/"$app_name"-AM.desktop
desktop_file2=~/.local/share/applications/"$app_name"-AM.desktop

# Setup
_log "Running multi-user launcher reinstall test: $0"
am --system

# Install in System Mode
_log "Installing $app_name in system mode..."
am -i "$app_name"
_test_apps "$app_name"

# Corrupt .desktop file and then fix it
_log "Corrupting and restoring $app_name launcher in system mode..."
checksum=$(md5sum "$desktop_file1")
dd if=/dev/urandom bs=1 count=6 seek=8 conv=notrunc of="$desktop_file1"
printf "Y\n" |\
am reinstall --launcher "$app_name"
md5sum "$desktop_file1" > "$test_results"
_check_count "$checksum" 1 "$test_results"

# Install in User Mode
_log "Installing $app_name in user mode..."
printf "Y\n" |\
am --user
am -i "$app_name"
_test_apps "$app_name"

# Corrupt .desktop file and then fix it
_log "Corrupting and restoring $app_name launcher in user mode..."
checksum=$(md5sum "$desktop_file2")
dd if=/dev/urandom bs=1 count=6 seek=8 conv=notrunc of="$desktop_file2"
printf "Y\n" |\
am reinstall --launcher "$app_name"
md5sum "$desktop_file2" > "$test_results"
_check_count "$checksum" 1 "$test_results"

# Pass the test
_remove_all_apps
_pass

