#!/usr/bin/env bash

# Tests for the fuzzy suggest feature (_levenshtein, _did_you_mean) in APP-MANAGER, and its users in modules/install.am and modules/management.am

# Source common test functions
. "$(dirname "$0")/test-common.sh"

# Test variables
test_results=".results.tmp"
PASS=0
FAIL=0

# Load the actual functions from the module
_appman="/opt/am/APP-MANAGER"
_module="/opt/am/modules/install.am"
_mgmt_module="/opt/am/modules/management.am"
eval "$(awk '/^_read\(\)/,/^}$/' "$_appman")"
eval "$(awk '/^_fit\(\)/,/^}$/' "$_appman")"
eval "$(awk '/^_levenshtein\(\)/,/^}$/' "$_appman")"
eval "$(awk '/^_print_did_you_mean_candidates\(\)/,/^}$/' "$_appman")"
eval "$(awk '/^_did_you_mean_list_names\(\)/,/^}$/' "$_appman")"
eval "$(awk '/^_did_you_mean\(\)/,/^}$/' "$_appman")"
eval "$(awk '/^_select_did_you_mean_candidate\(\)/,/^}$/' "$_appman")"
eval "$(awk '/^_check_arg_variants\(\)/,/^}$/' "$_module")"
eval "$(awk '/^_print_arg_variants_notice\(\)/,/^}$/' "$_module")"
eval "$(awk '/^_check_installed_arg\(\)/,/^}$/' "$_mgmt_module")"

# Variables required by _did_you_mean and _fit
AMDATADIR="${AMDATADIR:-$HOME/.local/share/AM}"
ARCH="${ARCH:-$(uname -m)}"
LightBlue="${LightBlue:-}"
command -v tput >/dev/null 2>&1 && TERMINAL_WIDTH=$(($(tput cols)-3)) || TERMINAL_WIDTH=${COLUMNS:-80}
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
	label="$1" got="$2" expected="$3"
	[ "$got" = "$expected" ] && _ok "$label" || _ko "$label" "$got" "$expected"
}

_assert_contains() {
	label="$1" haystack="$2" needle="$3"
	if echo "$haystack" | grep -q "$needle"; then
		_ok "$label"
	else
		_ko "$label" "(not found)" "$needle"
	fi
}

_assert_empty() {
	label="$1" value="$2"
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
	applist="${AMDATADIR:-$HOME/.local/share/AM}/${ARCH:-$(uname -m)}-apps"
	if [ ! -f "$applist" ]; then
		printf "\n=== _did_you_mean tests SKIPPED (no cached app list at %s) ===\n" "$applist"
		printf "SKIP: _did_you_mean tests — no app list cached\n" >> "$test_results"
		return
	fi

	printf "\n=== _did_you_mean unit tests ===\n"

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

	saved_amdatadir="$AMDATADIR"
	saved_tp="$third_party_lists"
	AMDATADIR="$tmpdir"
	third_party_lists="busybox appbundle"

	printf "\n=== _did_you_mean third-party tests ===\n"

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
# _did_you_mean substring-match tests (names far outside the length-diff /
# same-first-char heuristics that gate the Levenshtein pass)
################################################################################

_test_did_you_mean_substring() {
	tmpdir=$(mktemp -d)
	trap 'rm -rf "$tmpdir"' RETURN

	cat > "$tmpdir/${ARCH}-apps" <<'EOF'
◆ heroic-games-launcher : Native GOG, Epic and Amazon Games client
◆ hermit : Lightweight Chromium-based site-specific browser
EOF

	saved_amdatadir="$AMDATADIR"
	saved_tp="$third_party_lists"
	AMDATADIR="$tmpdir"
	third_party_lists=""

	printf "\n=== _did_you_mean substring-match tests ===\n"

	# Single substring match: "heroic" vs "heroic-games-launcher" is way
	# outside the len-diff/first-char/edit-distance heuristics, so this only
	# works via the substring pass.
	out=$(_did_you_mean "heroic")
	_assert_contains "heroic → suggests heroic-games-launcher" "$out" "heroic-games-launcher"
	_assert_contains "heroic → output contains 'Did you mean'" "$out" "Did you mean"

	DID_YOU_MEAN="" DID_YOU_MEAN_CANDIDATES=()
	_did_you_mean "heroic" > /dev/null
	_assert_eq "heroic → DID_YOU_MEAN=heroic-games-launcher" "$DID_YOU_MEAN" "heroic-games-launcher"
	_assert_eq "heroic → no candidate list (single match)" "${#DID_YOU_MEAN_CANDIDATES[@]}" "0"

	# Second substring match added → candidate list instead of a single guess
	cat >> "$tmpdir/${ARCH}-apps" <<'EOF'
◆ heroic-games-launcher-cli : CLI variant
EOF
	out=$(_did_you_mean "heroic")
	_assert_contains "heroic (2 matches) → lists heroic-games-launcher" "$out" "heroic-games-launcher"
	_assert_contains "heroic (2 matches) → lists heroic-games-launcher-cli" "$out" "heroic-games-launcher-cli"
	_assert_contains "heroic (2 matches) → 'multiple variants' header" "$out" "multiple variants"

	DID_YOU_MEAN="" DID_YOU_MEAN_CANDIDATES=()
	_did_you_mean "heroic" > /dev/null
	_assert_empty "heroic (2 matches) → DID_YOU_MEAN stays empty" "$DID_YOU_MEAN"
	_assert_eq "heroic (2 matches) → 2 candidates" "${#DID_YOU_MEAN_CANDIDATES[@]}" "2"
	_assert_eq "heroic (2 matches) → candidate[0]=heroic-games-launcher" "${DID_YOU_MEAN_CANDIDATES[0]}" "heroic-games-launcher"
	_assert_eq "heroic (2 matches) → candidate[1]=heroic-games-launcher-cli" "${DID_YOU_MEAN_CANDIDATES[1]}" "heroic-games-launcher-cli"

	# Short input (< 4 chars) must skip the substring pass entirely, or a
	# single letter would substring-match almost the whole database.
	DID_YOU_MEAN="" DID_YOU_MEAN_CANDIDATES=()
	out=$(_did_you_mean "her")
	if echo "$out" | grep -q "multiple variants"; then
		_ko "her (3 chars) → substring pass skipped, no flood" "(flooded)" "(skipped)"
	else
		_ok "her (3 chars) → substring pass skipped, no flood"
	fi
	_did_you_mean "her" > /dev/null
	_assert_eq "her (3 chars) → no candidate list" "${#DID_YOU_MEAN_CANDIDATES[@]}" "0"

	# Too many substring matches (> 15) is not a useful suggestion — bail to
	# no suggestion instead of dumping a huge list.
	rm -f "$tmpdir/${ARCH}-apps"
	{
		echo "◆ heroic-games-launcher : Native GOG, Epic and Amazon Games client"
		for i in $(seq 1 16); do
			echo "◆ zzflood$i-heroic-app : filler entry $i"
		done
	} > "$tmpdir/${ARCH}-apps"
	DID_YOU_MEAN="" DID_YOU_MEAN_CANDIDATES=()
	out=$(_did_you_mean "heroic")
	_assert_empty "heroic (>15 substring matches) → no suggestion output" "$out"
	_did_you_mean "heroic" > /dev/null
	_assert_empty "heroic (>15 substring matches) → DID_YOU_MEAN empty" "$DID_YOU_MEAN"
	_assert_eq "heroic (>15 substring matches) → no candidate list" "${#DID_YOU_MEAN_CANDIDATES[@]}" "0"

	AMDATADIR="$saved_amdatadir"
	third_party_lists="$saved_tp"
}

################################################################################
# _did_you_mean case-insensitivity tests
################################################################################

_test_did_you_mean_case_insensitive() {
	local tmpdir
	tmpdir=$(mktemp -d)
	trap 'rm -rf "$tmpdir"' RETURN

	cat > "$tmpdir/${ARCH}-apps" <<'EOF'
◆ sayonara : music player
◆ heroic-games-launcher : Native GOG, Epic and Amazon Games client
EOF

	local saved_amdatadir="$AMDATADIR"
	local saved_tp="$third_party_lists"
	AMDATADIR="$tmpdir"
	third_party_lists=""

	printf "\n=== _did_you_mean case-insensitivity tests ===\n"
	local out

	# Exact match, differing only by case → dist 0, no candidate list.
	DID_YOU_MEAN="" DID_YOU_MEAN_CANDIDATES=()
	out=$(_did_you_mean "Sayonara")
	_assert_contains "Sayonara → suggests sayonara" "$out" "sayonara"
	DID_YOU_MEAN="" DID_YOU_MEAN_CANDIDATES=()
	_did_you_mean "Sayonara" > /dev/null
	_assert_eq "Sayonara → DID_YOU_MEAN=sayonara" "$DID_YOU_MEAN" "sayonara"
	_assert_eq "Sayonara → no candidate list" "${#DID_YOU_MEAN_CANDIDATES[@]}" "0"

	# All-uppercase input, same exact-match behavior.
	DID_YOU_MEAN="" DID_YOU_MEAN_CANDIDATES=()
	_did_you_mean "SAYONARA" > /dev/null
	_assert_eq "SAYONARA → DID_YOU_MEAN=sayonara" "$DID_YOU_MEAN" "sayonara"

	# Substring match, differing only by case (input len >= 4).
	DID_YOU_MEAN="" DID_YOU_MEAN_CANDIDATES=()
	_did_you_mean "HEROIC" > /dev/null
	_assert_eq "HEROIC → DID_YOU_MEAN=heroic-games-launcher" "$DID_YOU_MEAN" "heroic-games-launcher"

	# Mixed-case substring, match found via the substring pass.
	DID_YOU_MEAN="" DID_YOU_MEAN_CANDIDATES=()
	_did_you_mean "HeRoIc" > /dev/null
	_assert_eq "HeRoIc → DID_YOU_MEAN=heroic-games-launcher" "$DID_YOU_MEAN" "heroic-games-launcher"

	AMDATADIR="$saved_amdatadir"
	third_party_lists="$saved_tp"
}

################################################################################
# _select_did_you_mean_candidate unit tests
################################################################################

_test_select_did_you_mean_candidate() {
	printf "\n=== _select_did_you_mean_candidate tests ===\n"

	DID_YOU_MEAN_CANDIDATES=("foo-one" "foo-two" "foo-three")
	DID_YOU_MEAN_CANDIDATE_FLAGS=("" "busybox" "")

	DID_YOU_MEAN="" DID_YOU_MEAN_FLAG=""
	if _select_did_you_mean_candidate <<< "2"; then
		_ok "select 2 → returns success"
	else
		_ko "select 2 → returns success" "failure" "success"
	fi
	_assert_eq "select 2 → DID_YOU_MEAN=foo-two"      "$DID_YOU_MEAN" "foo-two"
	_assert_eq "select 2 → DID_YOU_MEAN_FLAG=busybox" "$DID_YOU_MEAN_FLAG" "busybox"

	DID_YOU_MEAN="" DID_YOU_MEAN_FLAG=""
	if _select_did_you_mean_candidate <<< "0"; then
		_ko "select 0 → cancels" "success" "failure"
	else
		_ok "select 0 → cancels"
	fi
	_assert_empty "select 0 → DID_YOU_MEAN stays empty" "$DID_YOU_MEAN"

	DID_YOU_MEAN="" DID_YOU_MEAN_FLAG=""
	if _select_did_you_mean_candidate <<< "99"; then
		_ko "select out-of-range → rejected" "success" "failure"
	else
		_ok "select out-of-range → rejected"
	fi
	_assert_empty "select out-of-range → DID_YOU_MEAN stays empty" "$DID_YOU_MEAN"

	DID_YOU_MEAN="" DID_YOU_MEAN_FLAG=""
	if _select_did_you_mean_candidate <<< "abc"; then
		_ko "select non-numeric → rejected" "success" "failure"
	else
		_ok "select non-numeric → rejected"
	fi
	_assert_empty "select non-numeric → DID_YOU_MEAN stays empty" "$DID_YOU_MEAN"
}

################################################################################
# _check_arg_variants tests (exact-match name collision warning)
################################################################################

_test_check_arg_variants() {
	local tmpdir
	tmpdir=$(mktemp -d)
	trap 'rm -rf "$tmpdir"' RETURN

	cat > "$tmpdir/${ARCH}-apps" <<'EOF'
◆ photon : Cross-platform file-transfer application built using flutter.
◆ photon-studio : Free, offline photo editor.
◆ photoname : Rename photo image files based on EXIF shoot date.
◆ inkscape : Vector graphics editor
◆ gh : GitHub CLI
EOF

	local saved_amdatadir="$AMDATADIR"
	AMDATADIR="$tmpdir"

	printf "\n=== _check_arg_variants tests ===\n"

	# Exact match that is also a prefix/substring of other apps → collision
	if _check_arg_variants "photon"; then
		_ok "photon → collision detected"
	else
		_ko "photon → collision detected" "no collision" "collision"
	fi
	_assert_eq "photon → 3 candidates" "${#COLLISION_CANDIDATES[@]}" "3"
	_assert_contains "photon → candidates include photon-studio" "${COLLISION_CANDIDATES[*]}" "photon-studio"
	_assert_contains "photon → candidates include photoname" "${COLLISION_CANDIDATES[*]}" "photoname"

	# Exact match with no other app sharing the name → no collision
	if _check_arg_variants "inkscape"; then
		_ko "inkscape → no collision (unique app)" "collision" "no collision"
	else
		_ok "inkscape → no collision (unique app)"
	fi

	# Short input (< 4 chars) must skip the check entirely, same floor as the
	# substring pass in _did_you_mean, to avoid flooding on short exact names.
	if _check_arg_variants "gh"; then
		_ko "gh (2 chars) → check skipped" "collision" "no collision"
	else
		_ok "gh (2 chars) → check skipped"
	fi

	# Too many matches (> 15) is not a useful list either
	{
		cat "$tmpdir/${ARCH}-apps"
		for i in $(seq 1 16); do
			echo "◆ photon-flood$i : filler entry $i"
		done
	} > "$tmpdir/${ARCH}-apps.tmp" && mv "$tmpdir/${ARCH}-apps.tmp" "$tmpdir/${ARCH}-apps"
	if _check_arg_variants "photon"; then
		_ko "photon (>15 matches) → no collision list" "collision" "no collision"
	else
		_ok "photon (>15 matches) → no collision list"
	fi

	AMDATADIR="$saved_amdatadir"
}

################################################################################
# _print_arg_variants_notice tests (non-blocking heads-up on exact match)
################################################################################

_test_print_arg_variants_notice() {
	printf "\n=== _print_arg_variants_notice tests ===\n"

	LightBlue=""

	# Other apps share the name → prints a notice listing them, not the arg itself
	COLLISION_CANDIDATES=(photon photon-studio photoname)
	out=$(_print_arg_variants_notice "photon")
	_assert_contains "photon → notice mentions photon-studio" "$out" "photon-studio"
	_assert_contains "photon → notice mentions photoname" "$out" "photoname"
	if echo "$out" | grep -qE "matches: photon,|matches: photon$"; then
		_ko "photon → notice excludes itself from the list" "(found)" "(absent)"
	else
		_ok "photon → notice excludes itself from the list"
	fi

	# Only the exact match itself in COLLISION_CANDIDATES → no notice
	COLLISION_CANDIDATES=(photon-studio)
	out=$(_print_arg_variants_notice "photon-studio")
	_assert_empty "photon-studio (no other matches) → no notice" "$out"

	# Never blocks: no _read/prompt involved, just prints and returns
	COLLISION_CANDIDATES=(photon photon-studio)
	if _print_arg_variants_notice "photon" < /dev/null; then
		_ok "notice runs fine with closed stdin (non-interactive safe)"
	else
		_ko "notice runs fine with closed stdin (non-interactive safe)" "failure" "success"
	fi
}

################################################################################
# Installed-app suggestions (appman -r photon → photon-studio)
################################################################################

_test_did_you_mean_installed() {
	printf "\n=== _did_you_mean installed-apps tests ===\n"

	local saved_argpaths="$ARGPATHS" saved_argpath="$argpath" saved_arg="$arg" out

	# Single substring match among installed apps
	ARGPATHS=$'/home/u/Applications/photon-studio\n/home/u/Applications/htop'
	DID_YOU_MEAN="" DID_YOU_MEAN_FLAG="" DID_YOU_MEAN_CANDIDATES=()
	out=$(_did_you_mean "photon" installed)
	_assert_contains "photon (installed) → suggests photon-studio" "$out" "photon-studio"
	_did_you_mean "photon" installed > /dev/null
	_assert_eq "photon (installed) → DID_YOU_MEAN=photon-studio" "$DID_YOU_MEAN" "photon-studio"
	_assert_empty "photon (installed) → no flag" "$DID_YOU_MEAN_FLAG"

	# Typo among installed apps
	DID_YOU_MEAN="" DID_YOU_MEAN_CANDIDATES=()
	_did_you_mean "htoop" installed > /dev/null
	_assert_eq "htoop (installed) → DID_YOU_MEAN=htop" "$DID_YOU_MEAN" "htop"

	# Several matches → candidate list
	ARGPATHS=$'/home/u/Applications/photon-studio\n/home/u/Applications/photocraft\n/home/u/Applications/htop'
	DID_YOU_MEAN="" DID_YOU_MEAN_CANDIDATES=()
	_did_you_mean "photo" installed > /dev/null
	_assert_eq "photo (installed) → 2 candidates" "${#DID_YOU_MEAN_CANDIDATES[@]}" "2"
	_assert_eq "photo (installed) → candidate[0]=photocraft (sorted)" "${DID_YOU_MEAN_CANDIDATES[0]}" "photocraft"

	# Same app installed twice (system + local) is listed once
	ARGPATHS=$'/opt/photocraft\n/home/u/Applications/photocraft\n/home/u/Applications/photon-studio'
	DID_YOU_MEAN="" DID_YOU_MEAN_CANDIDATES=()
	_did_you_mean "photo" installed > /dev/null
	_assert_eq "photo (installed twice) → 2 candidates, no duplicate" "${#DID_YOU_MEAN_CANDIDATES[@]}" "2"

	# Not-installed apps from the database are never suggested
	ARGPATHS=$'/home/u/Applications/htop'
	DID_YOU_MEAN="" DID_YOU_MEAN_CANDIDATES=()
	out=$(_did_you_mean "photon" installed)
	_assert_empty "photon (not installed) → no suggestion" "$out"
	_assert_empty "photon (not installed) → DID_YOU_MEAN empty" "$DID_YOU_MEAN"

	ARGPATHS="$saved_argpaths" argpath="$saved_argpath" arg="$saved_arg"
}

_test_check_installed_arg() {
	printf "\n=== _check_installed_arg tests ===\n"

	local tmpdir saved_argpaths="$ARGPATHS" saved_argpath="$argpath" saved_arg="$arg"
	tmpdir=$(mktemp -d)
	trap 'rm -rf "$tmpdir"' RETURN
	mkdir -p "$tmpdir/photon-studio" "$tmpdir/photocraft" "$tmpdir/htop"
	touch "$tmpdir/photon-studio/remove" "$tmpdir/photocraft/remove" "$tmpdir/htop/remove"
	ARGPATHS="$tmpdir/photon-studio"$'\n'"$tmpdir/photocraft"$'\n'"$tmpdir/htop"
	AMCLI=am RED="" Green=""
	# Real _determine_argpath, as used by remove
	eval "$(awk '/^_determine_argpath\(\)/,/^}$/' "$_appman")"

	# Installed app → accepted without prompting
	arg="htop" argpath="$tmpdir/htop"
	_check_installed_arg > /dev/null </dev/null
	_assert_eq "htop installed → accepted" "$?" "0"

	# Not installed, one close match → accepted on Y, arg/argpath re-pointed
	arg="photon-studi" argpath=""
	_check_installed_arg > /dev/null <<< "y"
	_assert_eq "photon-studi + Y → accepted" "$?" "0"
	_assert_eq "photon-studi + Y → arg=photon-studio" "$arg" "photon-studio"
	_assert_eq "photon-studi + Y → argpath set" "$argpath" "$tmpdir/photon-studio"

	# Declined with N → rejected, arg untouched
	arg="photon-studi" argpath=""
	_check_installed_arg > /dev/null <<< "n"
	_assert_eq "photon-studi + N → rejected" "$?" "1"
	_assert_eq "photon-studi + N → arg unchanged" "$arg" "photon-studi"

	# Several close matches → pick by number
	arg="photon" argpath=""
	_check_installed_arg > /dev/null <<< "1"
	_assert_eq "photon + pick 1 → accepted" "$?" "0"
	_assert_eq "photon + pick 1 → arg=photon-studio" "$arg" "photon-studio"

	# Installed twice (system + local) → asks which path, and rejects a bad answer
	mkdir -p "$tmpdir/loc/photocraft" "$tmpdir/sys/photocraft"
	touch "$tmpdir/loc/photocraft/remove" "$tmpdir/sys/photocraft/remove"
	ARGPATHS="$tmpdir/sys/photocraft"$'\n'"$tmpdir/loc/photocraft"
	arg="photocraf" argpath=""
	_check_installed_arg > /dev/null <<< $'y\n2'
	_assert_eq "photocraf (2 installs) + Y + path 2 → accepted" "$?" "0"
	_assert_eq "photocraf (2 installs) + path 2 → argpath=loc" "$argpath" "$tmpdir/loc/photocraft"
	for bad in "" "x" "9"; do
		arg="photocraf" argpath=""
		out=$(_check_installed_arg <<< $'y\n'"$bad" 2>&1)
		_assert_eq "photocraf (2 installs) + path '$bad' → rejected" "$?" "1"
		if echo "$out" | grep -q "awk"; then
			_ko "photocraf (2 installs) + path '$bad' → no awk error" "(awk error)" "(none)"
		else
			_ok "photocraf (2 installs) + path '$bad' → no awk error"
		fi
	done
	ARGPATHS="$tmpdir/photon-studio"$'\n'"$tmpdir/photocraft"$'\n'"$tmpdir/htop"

	# Installed twice, path choice aborted (argpath empty) → rejected quietly,
	# no "not a valid APPNAME" error and no suggestion of itself
	ARGPATHS="$tmpdir/sys/photocraft"$'\n'"$tmpdir/loc/photocraft"
	arg="photocraft" argpath=""
	out=$(_check_installed_arg 2>&1 </dev/null)
	_assert_eq "photocraft (2 installs, path aborted) → rejected" "$?" "1"
	_assert_empty "photocraft (2 installs, path aborted) → no output" "$out"
	ARGPATHS="$tmpdir/photon-studio"$'\n'"$tmpdir/photocraft"$'\n'"$tmpdir/htop"

	# Nothing similar → rejected
	arg="qqqxxx" argpath=""
	_check_installed_arg > /dev/null </dev/null
	_assert_eq "qqqxxx → rejected" "$?" "1"

	ARGPATHS="$saved_argpaths" argpath="$saved_argpath" arg="$saved_arg"
}

################################################################################
# Main
################################################################################

_log "Running fuzzy-suggest tests: $0"

_test_levenshtein
_test_did_you_mean
_test_did_you_mean_tp
_test_did_you_mean_substring
_test_did_you_mean_case_insensitive
_test_select_did_you_mean_candidate
_test_check_arg_variants
_test_print_arg_variants_notice
_test_did_you_mean_installed
_test_check_installed_arg

printf "\n=== Results: \033[0;32m%d passed\033[0m, \033[0;31m%d failed\033[0m ===\n\n" "$PASS" "$FAIL"
printf "Results: %d passed, %d failed\n" "$PASS" "$FAIL" >> "$test_results"

[ "$FAIL" -gt 0 ] && _fail "$FAIL test(s) failed."
_pass
