#!/usr/bin/env bash

# Simple script for testing all functions of AM

n=0
((n++))
function _check() {
	printf '%s - %s\n\n%s' "${1}" "${3}" "$(am ${2} || echo "FAIL: ${1}" && exit $n)"
}

function list_apps() {
	am list
}

function _pick_app() {
	randomApp=$(cut -d' ' -f2 < /opt/am/x86_64-apps | shuf -n 1)
}

# Test needs: Items in brackets [] are optional
# Use '' or "" for arguments with more words!
#_check <Name of test> <command> [Short info]

_pick_app
printf '\n-----------------------------------------------------------------------------\n\n\t\tAM testing started\n\n-----------------------------------------------------------------------------\n\n'
_check am am 'no argument'

printf '\n-----------------------------------------------------------------------------\n\n'
_check version version

printf '\n-----------------------------------------------------------------------------\n\n'
_check 'files --less' 'files --less' 'Number of installed apps'

printf '\n-----------------------------------------------------------------------------\n\n'
_check "install ${randomApp}" "install ${randomApp}" "Install random app"

printf '\n-----------------------------------------------------------------------------\n\n'
_check 'files --less' 'files --less' 'Installed apps'

#_check files files 'Installed apps'

#_check 'files --byname' 'files --byname' 'Installed apps by name'

#_check help help 'Help message'

#_check 'update apps' 'update --apps' 'Update Apps'

#_check list list 'List available Apps'

printf '\n-----------------------------------------------------------------------------\n\n'
_check "remove ${randomApp}" "remove ${randomApp}" "Remove random app"

printf '\n-----------------------------------------------------------------------------\n\n'
_check 'files --less' 'files --less' 'Number of installed apps'

printf '\n-----------------------------------------------------------------------------\n\n'

printf '\n-----------------------------------------------------------------------------\n\n'

printf '\n-----------------------------------------------------------------------------\n\n'

printf '\n-----------------------------------------------------------------------------\n\n'

printf '\n-----------------------------------------------------------------------------\n\n'

printf '\n-----------------------------------------------------------------------------\n\n'

printf '\n-----------------------------------------------------------------------------\n\n\t\tAM testing Finished\n\n-----------------------------------------------------------------------------\n\n'

exit 0
