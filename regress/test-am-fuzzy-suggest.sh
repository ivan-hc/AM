#!/usr/bin/env bash

# Tests for the fuzzy suggest feature (_levenshtein, _did_you_mean) in modules/install.am

# Source common test functions
. "$(dirname "$0")/test-common.sh"

# Test variables
test_results=".results.tmp"
PASS=0
FAIL=0

# Load the actual functions from the module
_module="/opt/am/modules/install.am"
eval "$(awk '/^_levenshtein\(\)/,/^}$/' "$_module")"
eval "$(awk '/^_did_you_mean\(\)/,/^}$/' "$_module")"

# Variables required by _did_you_mean
AMDATADIR="${AMDATADIR:-$HOME/.local/share/AM}"
ARCH="${ARCH:-$(uname -m)}"
LightBlue="${LightBlue:-}"
third_party_lists="${third_party_lists:-}"

################################################################################
# Assertion helpers
################################################################################

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
	local label="$1" got="$2" expected="$3"
	[ "$got" = "$expected" ] && _ok "$label" || _ko "$label" "$got" "$expected"
}

_assert_contains() {
	local label="$1" haystack="$2" needle="$3"
	if echo "$haystack" | grep -q "$needle"; then
		_ok "$label"
	else
		_ko "$label" "(not found)" "$needle"
	fi
}

_assert_empty() {
	local label="$1" value="$2"
	[ -z "$value" ] && _ok "$label" || _ko "$label" "$value" "(empty)"
}

################################################################################
# _levenshtein unit tests
################################################################################

_test_levenshtein() {
	printf "\n=== _levenshtein unit tests ===\n"

	# Trivial cases
	_assert_eq "identical strings → 0"            "$(_levenshtein 'abc' 'abc')"       0
	_assert_eq "empty vs empty → 0"               "$(_levenshtein '' '')"              0
	_assert_eq "empty vs string → string length"  "$(_levenshtein '' 'hello')"         5
	_assert_eq "string vs empty → string length"  "$(_levenshtein 'hello' '')"         5
	_assert_eq "single char same → 0"             "$(_levenshtein 'x' 'x')"            0
	_assert_eq "single char diff → 1"             "$(_levenshtein 'x' 'y')"            1

	# One edit
	_assert_eq "one substitution (cat→bat) → 1"   "$(_levenshtein 'cat' 'bat')"        1
	_assert_eq "one insertion (cat→cats) → 1"     "$(_levenshtein 'cat' 'cats')"       1
	_assert_eq "one deletion (cats→cat) → 1"      "$(_levenshtein 'cats' 'cat')"       1

	# Classic test vectors
	_assert_eq "kitten→sitting → 3"               "$(_levenshtein 'kitten' 'sitting')" 3
	_assert_eq "sunday→saturday → 3"              "$(_levenshtein 'sunday' 'saturday')" 3
	_assert_eq "abc→xyz (full replace) → 3"       "$(_levenshtein 'abc' 'xyz')"         3

	# Case-sensitivity
	_assert_eq "case-sensitive: abc≠Abc → 1"      "$(_levenshtein 'abc' 'Abc')"         1
	_assert_eq "case-sensitive: abc≠ABC → 3"      "$(_levenshtein 'abc' 'ABC')"         3

	# Realistic app-name typos
	_assert_eq "amydesk→anydesk (1 subst) → 1"       "$(_levenshtein 'amydesk' 'anydesk')"     1
	_assert_eq "inkscap→inkscape (1 del) → 1"         "$(_levenshtein 'inkscap' 'inkscape')"    1
	_assert_eq "zen-browser2→zen-browser (1 del) → 1" "$(_levenshtein 'zen-browser2' 'zen-browser')" 1
	_assert_eq "audaxity→audacity (1 subst) → 1"      "$(_levenshtein 'audaxity' 'audacity')"   1
	_assert_eq "inksacpe→inkscape (2 subst) → 2"      "$(_levenshtein 'inksacpe' 'inkscape')"   2
	_assert_eq "blenders→blender (1 ins) → 1"         "$(_levenshtein 'blenders' 'blender')"    1
	_assert_eq "blendr→blender (1 del) → 1"           "$(_levenshtein 'blendr' 'blender')"      1

	# Short app names (2–4 chars)
	_assert_eq "gim→gimp (1 del) → 1"    "$(_levenshtein 'gim' 'gimp')"   1
	_assert_eq "batt→bat (1 ins) → 1"    "$(_levenshtein 'batt' 'bat')"   1
	_assert_eq "fdd→fd (1 ins) → 1"      "$(_levenshtein 'fdd' 'fd')"     1
	_assert_eq "ghh→gh (1 ins) → 1"      "$(_levenshtein 'ghh' 'gh')"     1
	_assert_eq "jqq→jq (1 ins) → 1"      "$(_levenshtein 'jqq' 'jq')"     1
	_assert_eq "nvimm→nvim (1 ins) → 1"  "$(_levenshtein 'nvimm' 'nvim')" 1
	_assert_eq "viim→vifm (1 subst) → 1" "$(_levenshtein 'viim' 'vifm')"  1
	_assert_eq "bat→bat (exact) → 0"     "$(_levenshtein 'bat' 'bat')"    0
}

################################################################################
# _did_you_mean unit tests (require cached app list)
################################################################################

_test_did_you_mean() {
	local applist="${AMDATADIR:-$HOME/.local/share/AM}/${ARCH:-$(uname -m)}-apps"
	if [ ! -f "$applist" ]; then
		printf "\n=== _did_you_mean tests SKIPPED (no cached app list at %s) ===\n" "$applist"
		printf "SKIP: _did_you_mean tests — no app list cached\n" >> "$test_results"
		return
	fi

	printf "\n=== _did_you_mean unit tests ===\n"
	local out

	# Extra char at end
	out=$(_did_you_mean "zen-browser2")
	_assert_contains "zen-browser2 → suggests zen-browser"  "$out" "zen-browser"
	_assert_contains "zen-browser2 → output contains 'Did you mean'" "$out" "Did you mean"

	out=$(_did_you_mean "inkscape1")
	_assert_contains "inkscape1 → suggests inkscape"        "$out" "inkscape"

	out=$(_did_you_mean "blenders")
	_assert_contains "blenders → suggests blender"          "$out" "blender"

	# Missing char at end
	out=$(_did_you_mean "inkscap")
	_assert_contains "inkscap → suggests inkscape"          "$out" "inkscape"

	out=$(_did_you_mean "blende")
	_assert_contains "blende → suggests blender"            "$out" "blender"

	# One wrong char in middle
	out=$(_did_you_mean "amydesk")
	_assert_contains "amydesk → suggests anydesk"           "$out" "anydesk"

	out=$(_did_you_mean "audaxity")
	_assert_contains "audaxity → suggests audacity"         "$out" "audacity"

	# Transposed chars (distance = 2, within threshold)
	out=$(_did_you_mean "inksacpe")
	_assert_contains "inksacpe → suggests inkscape"         "$out" "inkscape"

	# Missing char in middle
	out=$(_did_you_mean "blendr")
	_assert_contains "blendr → suggests blender"            "$out" "blender"

	# Short app names (2–4 chars): extra char, missing char, wrong char
	out=$(_did_you_mean "gim")
	_assert_contains "gim → suggests gimp"    "$out" "gimp"

	out=$(_did_you_mean "nvimm")
	_assert_contains "nvimm → suggests nvim"  "$out" "nvim"

	out=$(_did_you_mean "fdd")
	_assert_contains "fdd → suggests fd"      "$out" "fd"

	out=$(_did_you_mean "ghh")
	_assert_contains "ghh → suggests gh"      "$out" "gh"

	out=$(_did_you_mean "jqq")
	_assert_contains "jqq → suggests jq"      "$out" "jq"

	out=$(_did_you_mean "viim")
	_assert_contains "viim → suggests vifm"   "$out" "vifm"

	out=$(_did_you_mean "batt")
	_assert_contains "batt → suggests bat"    "$out" "bat"

	# Separator variants: dash omitted, replaced with underscore or space
	out=$(_did_you_mean "zenbrowser")
	_assert_contains "zenbrowser (no dash) → suggests zen-browser"          "$out" "zen-browser"

	out=$(_did_you_mean "zen_browser")
	_assert_contains "zen_browser (underscore) → suggests zen-browser"      "$out" "zen-browser"

	out=$(_did_you_mean "zen browser")
	_assert_contains "zen browser (space) → suggests zen-browser"           "$out" "zen-browser"

	out=$(_did_you_mean "openvideodownloader")
	_assert_contains "openvideodownloader (no dashes) → suggests open-video-downloader" "$out" "open-video-downloader"

	out=$(_did_you_mean "openvideo-downloader")
	_assert_contains "openvideo-downloader (dash shifted) → suggests open-video-downloader" "$out" "open-video-downloader"

	out=$(_did_you_mean "open-videodownloader")
	_assert_contains "open-videodownloader (dash shifted) → suggests open-video-downloader" "$out" "open-video-downloader"

	out=$(_did_you_mean "lossless-cut")
	_assert_contains "lossless-cut (extra dash) → suggests losslesscut"     "$out" "losslesscut"

	out=$(_did_you_mean "lossless_cut")
	_assert_contains "lossless_cut (underscore) → suggests losslesscut"     "$out" "losslesscut"

	# Suggestion format: output must include 'Did you mean' phrase
	out=$(_did_you_mean "amydesk")
	_assert_contains "suggestion includes 'Did you mean' text" "$out" "Did you mean"

	# DID_YOU_MEAN variable is set on match, empty on no match
	DID_YOU_MEAN=""
	_did_you_mean "amydesk" > /dev/null
	_assert_eq "DID_YOU_MEAN set to anydesk on match"    "$DID_YOU_MEAN" "anydesk"

	DID_YOU_MEAN=""
	_did_you_mean "zzzznotanapp" > /dev/null
	_assert_empty "DID_YOU_MEAN empty on no match"       "$DID_YOU_MEAN"

	# No suggestion: completely unrelated string
	out=$(_did_you_mean "zzzznotanapp")
	_assert_empty "zzzznotanapp → no suggestion"            "$out"

	# No suggestion: string too different from any app (distance > threshold)
	out=$(_did_you_mean "qqqxxx")
	_assert_empty "qqqxxx (no app within edit-distance 2) → no suggestion" "$out"

	out=$(_did_you_mean "anydesk")
	_assert_contains "anydesk (exact DB name) → still finds the app" "$out" "anydesk"
}

################################################################################
# _did_you_mean third-party database tests
################################################################################

_test_did_you_mean_tp() {
	local tmpdir
	tmpdir=$(mktemp -d)
	trap 'rm -rf "$tmpdir"' RETURN

	# Fake main app list
	cat > "$tmpdir/${ARCH}-apps" <<'EOF'
◆ inkscape : Vector graphics editor
◆ blender : 3D creation suite
◆ anydesk : Remote desktop tool
EOF

	# Fake tp lists
	cat > "$tmpdir/${ARCH}-busybox" <<'EOF'
◆ acpid : Listen to ACPI events. To install it use the --busybox flag or the .busybox extension.
◆ adduser : Add a user to the System. To install it use the --busybox flag or the .busybox extension.
EOF

	cat > "$tmpdir/${ARCH}-appbundle" <<'EOF'
◆ xfce4-multicall : Xfce4 multicall binary. To install it use the --appbundle flag or the .appbundle extension.
◆ xfce4-terminal : Terminal emulator. To install it use the --appbundle flag or the .appbundle extension.
EOF

	local saved_amdatadir="$AMDATADIR"
	local saved_tp="$third_party_lists"
	AMDATADIR="$tmpdir"
	third_party_lists="busybox appbundle"

	printf "\n=== _did_you_mean third-party tests ===\n"
	local out

	# Exact match in tp list → special message, flag set
	out=$(_did_you_mean "xfce4-multicall")
	_assert_contains "xfce4-multicall exact → mentions app name"       "$out" "xfce4-multicall"
	_assert_contains "xfce4-multicall exact → mentions appbundle"      "$out" "appbundle"
	DID_YOU_MEAN="" DID_YOU_MEAN_FLAG=""
	_did_you_mean "xfce4-multicall" > /dev/null
	_assert_eq "xfce4-multicall exact → DID_YOU_MEAN set"              "$DID_YOU_MEAN" "xfce4-multicall"
	_assert_eq "xfce4-multicall exact → DID_YOU_MEAN_FLAG=appbundle"   "$DID_YOU_MEAN_FLAG" "appbundle"

	# Exact match in tp list → no "Did you mean" phrase
	out=$(_did_you_mean "xfce4-multicall")
	if echo "$out" | grep -q "Did you mean"; then
		_ko "xfce4-multicall exact → no 'Did you mean' phrase" "(found)" "(absent)"
	else
		_ok "xfce4-multicall exact → no 'Did you mean' phrase"
	fi

	# Fuzzy match in tp list → "Did you mean" + flag
	out=$(_did_you_mean "acpid2")
	_assert_contains "acpid2 → suggests acpid"                         "$out" "acpid"
	_assert_contains "acpid2 → output contains 'Did you mean'"         "$out" "Did you mean"
	DID_YOU_MEAN="" DID_YOU_MEAN_FLAG=""
	_did_you_mean "acpid2" > /dev/null
	_assert_eq "acpid2 → DID_YOU_MEAN=acpid"                           "$DID_YOU_MEAN" "acpid"
	_assert_eq "acpid2 → DID_YOU_MEAN_FLAG=busybox"                    "$DID_YOU_MEAN_FLAG" "busybox"

	# Match in main list wins over tp list (anydesk is in main, not tp)
	DID_YOU_MEAN="" DID_YOU_MEAN_FLAG=""
	_did_you_mean "amydesk" > /dev/null
	_assert_eq "amydesk → DID_YOU_MEAN=anydesk (main list)"            "$DID_YOU_MEAN" "anydesk"
	_assert_eq "amydesk → DID_YOU_MEAN_FLAG empty (main list)"         "$DID_YOU_MEAN_FLAG" ""

	# With only_flag: search restricted to that tp list
	DID_YOU_MEAN="" DID_YOU_MEAN_FLAG=""
	_did_you_mean "acpid2" "busybox" > /dev/null
	_assert_eq "acpid2 --busybox → DID_YOU_MEAN=acpid"                 "$DID_YOU_MEAN" "acpid"

	DID_YOU_MEAN="" DID_YOU_MEAN_FLAG=""
	_did_you_mean "acpid2" "appbundle" > /dev/null
	_assert_empty "acpid2 --appbundle → no match (acpid not in appbundle)" "$DID_YOU_MEAN"

	# Exact match in multiple tp lists → first list wins
	cat >> "$tmpdir/${ARCH}-appbundle" <<'EOF'
◆ acpid : Also in appbundle. To install it use the --appbundle flag or the .appbundle extension.
EOF
	DID_YOU_MEAN="" DID_YOU_MEAN_FLAG=""
	_did_you_mean "acpid" > /dev/null
	_assert_eq "acpid in busybox+appbundle → first list (busybox) wins" "$DID_YOU_MEAN_FLAG" "busybox"

	# No match anywhere
	DID_YOU_MEAN="" DID_YOU_MEAN_FLAG=""
	_did_you_mean "qqqxxx" > /dev/null
	_assert_empty "qqqxxx → no match in any list" "$DID_YOU_MEAN"

	AMDATADIR="$saved_amdatadir"
	third_party_lists="$saved_tp"
}

################################################################################
# Main
################################################################################

_log "Running fuzzy-suggest tests: $0"

_test_levenshtein
_test_did_you_mean
_test_did_you_mean_tp

printf "\n=== Results: \033[0;32m%d passed\033[0m, \033[0;31m%d failed\033[0m ===\n\n" "$PASS" "$FAIL"
printf "Results: %d passed, %d failed\n" "$PASS" "$FAIL" >> "$test_results"

[ "$FAIL" -gt 0 ] && _fail "$FAIL test(s) failed."
_pass
