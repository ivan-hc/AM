#!/usr/bin/env sh

# Source common test functions
. "$(dirname "$0")/test-common.sh"

# Test variables
test_results=".results.tmp"
app_name1=$(_pick_random_app "$TEST_APP_LIST_DOWN")

## Setup
_log "Running version rollback test: $0"
am --system
am -R "$app_name1"

# Install app
_log "Installing $app_name1..."
am -i "$app_name1"
am -f > "$test_results"
_check_count "$app_name1.*|" 1 "$test_results"
app_ver_latest="$(_get_app_info "$app_name1" 2)"

# Test rollback
_log "Test rollback $app_name1..."
printf "y\n2\n" |\
am downgrade "$app_name1"
app_ver_old="$(_get_app_info "$app_name1" 2)"
[ "$app_ver_old" = "$app_ver_latest" ] && _fail "Error: \"$app_name1\" version rollback failed"

# Test lock
_log "Test lock $app_name1..."
printf "y\n" |\
am lock "$app_name1"
app_ver_old_locked="$(_get_app_info "$app_name1" 2)"
[ "$app_ver_old_locked" = "$app_ver_old" ] && _fail "Error: \"$app_name1\" version lock failed"

# Test backup
_log "Backing up old version of $app_name1..."
printf "y\n\n" |\
am backup "$app_name1"

# Try to update locked app
_log "Test update locked $app_name1..."
am -u "$app_name1" > "$test_results"
_check_count "cannot be updated" 1 "$test_results"
app_ver_old_updated="$(_get_app_info "$app_name1" 2)"
[ "$app_ver_old_updated" = "$app_ver_latest" ] && _fail "Error: \"$app_name1\" version updated despite locked status"

# Test unlock
_log "Test unlock $app_name1..."
printf "y\n" |\
am unlock "$app_name1"
app_ver_old_unlocked="$(_get_app_info "$app_name1" 2)"
[ "$app_ver_old_unlocked" != "$app_ver_old" ] && _fail "Error: \"$app_name1\" version unlock failed"

# Update unlocked app
_log "Test update unlocked $app_name1..."
am -u "$app_name1" > "$test_results"
_check_count "cannot be updated" 0 "$test_results"
app_ver_old_updated="$(_get_app_info "$app_name1" 2)"
[ "$app_ver_old_updated" != "$app_ver_latest" ] && _fail "Error: \"$app_name1\" version cannot be updated despite unlocked status"

# Test restore
_log "Test restore backed up version of $app_name1..."
printf "y\n1\n" |\
am -o "$app_name1"
app_ver_old_restored="$(_get_app_info "$app_name1" 2)"
[ "$app_ver_old_restored" != "$app_ver_old_locked" ] && _fail "Error: \"$app_name1\" version was not restored correctly"

# Pass the test
rm -rf ~/.am-snapshots
_remove_all_apps
_pass

