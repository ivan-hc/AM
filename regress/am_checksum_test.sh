#!/usr/bin/env bash

# Error checking function
_check_count () {
if [ "$(grep -i "$2" "$1" | wc -l)" != "$3" ]; then
	echo Error: Test failed, $2 should occur $3 times.
	exit
fi
}

# Test install (system)
am --system
am -r zsync2
am -i zsync2 > .results

# Check for errors
_check_count .results "checksum verified" 1

# Pass the test if all was good
echo "Test passed!"

