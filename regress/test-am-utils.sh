#!/usr/bin/env sh

# Source common test functions
. "$(dirname "$0")/test-common.sh"

# Test variables
test_results=".results.tmp"
app_name1=$(_pick_random_app "$TEST_APP_LIST_XZ")
app_name2=$(_pick_random_app "$TEST_APP_LIST_ZIP")
app_name3=$(_pick_random_app "$TEST_APP_LIST_DIG")
app_name4=$(_pick_random_app "$TEST_APP_LIST_ZSYNC")
all_apps="$app_name1 $app_name2 $app_name3 $app_name4"

# Setup
_log "Running am-utils dependency test: $0"

# Hide core tools and check if AM detects them as missing
_hide_binaries "$AM_OPT_DEPS"
printf "N\n" |\
am clean
printf "N\n" |\
am --system
am -f > "$test_results"
_check_count "Missing command(s)" 1 "$test_results"

# Force AM to download them (Y first, then N if experiencing network issues)
rm -f ~/.local/share/AM/disable-dependencies-prompt
printf "Y\n" |\
am -f
printf "N\n" |\
am -f > "$test_results"
_check_count "Missing command(s)" 0 "$test_results"

# Install in System Mode
_log "Installing all apps in system mode..."
am -i "$all_apps" > "$test_results"
_check_count "checksum.*verified" 4 "$test_results"
_test_apps "$all_apps"

# Install in User Mode
_log "Installing all apps in user mode..."
am -R "$all_apps"
printf "Y\n" |\
am --user
am -i "$all_apps" > "$test_results"
_check_count "checksum.*verified" 4 "$test_results"
_test_apps "$all_apps"

# Restore binaries
_restore_binaries "$AM_OPT_DEPS"
am clean
printf "N\n" |\
am -f > "$test_results"
_check_count "Missing command(s)" 0 "$test_results"

# Pass the test
_remove_all_apps
_pass

