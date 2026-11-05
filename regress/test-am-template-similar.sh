#!/usr/bin/env bash

# Tests for _template_similar_names in modules/template.am (warning about similar app names when creating a template)

# Source common test functions
. "$(dirname "$0")/test-common.sh"

# Test variables
test_results=".results.tmp"
PASS=0
FAIL=0

# Load the actual functions from the modules
_appman="/opt/am/APP-MANAGER"
_module="${AM_TEMPLATE_MODULE:-/opt/am/modules/template.am}"
eval "$(awk '/^_template_similar_names\(\)/,/^}$/' "$_module")"

# Fake database, so the tests do not depend on the real lists
AMDATADIR="$(mktemp -d)"
ARCH="test"
cat > "$AMDATADIR/$ARCH-apps" <<LIST
◆ legcord : Discord client.
◆ st : Simple terminal.
◆ t3-code : Coding agent GUI.
◆ t3code : Coding agent GUI.
◆ vlc : Media player.
LIST
trap 'rm -rf "$AMDATADIR"' EXIT

_ok() {
	printf "  \033[0;32m✔\033[0m  %s\n" "$1"
	printf "PASS: %s\n" "$1" >> "$test_results"
	PASS=$(( PASS + 1 ))
}

_ko() {
	printf "  \033[0;31m✘\033[0m  %s\n" "$1"
	printf "      got:      '%s'\n" "$2"
	printf "      expected: '%s'\n" "$3"
	printf "FAIL: %s | got='%s' expected='%s'\n" "$1" "$2" "$3" >> "$test_results"
	FAIL=$(( FAIL + 1 ))
}

_assert_eq() {
	label="$1" got="$2" expected="$3"
	[ "$got" = "$expected" ] && _ok "$label" || _ko "$label" "$got" "$expected"
}

_test_template_similar_names() {
	printf "\n=== _template_similar_names ===\n"

	_assert_eq "t3-cod (one deletion) → t3-code t3code"  "$(_template_similar_names t3-cod | tr '\n' ' ')" "t3-code t3code "
	_assert_eq "t3_code (separator differs) → both"       "$(_template_similar_names t3_code | tr '\n' ' ')" "t3-code t3code "
	_assert_eq "t3.code (separator differs) → both"       "$(_template_similar_names t3.code | tr '\n' ' ')" "t3-code t3code "
	_assert_eq "legcor (one deletion) → legcord"          "$(_template_similar_names legcor)" "legcord"
	_assert_eq "t3eod (two edits, different app) → none"  "$(_template_similar_names t3eod)" ""
	_assert_eq "brandnewapp → none"                       "$(_template_similar_names brandnewapp)" ""
	_assert_eq "vlcc (4 chars, one edit from vlc) → vlc" "$(_template_similar_names vlcc)" "vlc"
	_assert_eq "short name sx (no fuzzy under 4 chars) → none" "$(_template_similar_names sx)" ""
	_assert_eq "short name s-t (only separators differ) → st" "$(_template_similar_names s-t)" "st"
}

_log "Running template similar-names tests: $0"

_test_template_similar_names

printf "\n=== Results: \033[0;32m%d passed\033[0m, \033[0;31m%d failed\033[0m ===\n\n" "$PASS" "$FAIL"
printf "Results: %d passed, %d failed\n" "$PASS" "$FAIL" >> "$test_results"

[ "$FAIL" -gt 0 ] && _fail "$FAIL test(s) failed."
_pass
