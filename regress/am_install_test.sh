#!/usr/bin/env bash

# Error checking function
_check_count () {
if [ "$(grep -i $2 $1 | wc -l)" != $3 ]; then
	echo Error: Test failed, $2 should occur $3 times.
	exit
fi
}

# Test install (system)
am --system
am -i zsync2

# Test install (user)
am --user
am -i zsync2

# Check listing
am --system

# Check for errors
am -f > .results
_check_count .results zsync2 2

# Test removal
am --user
am -r zsync2

# Check for errors
am -f > .results
_check_count .results zsync2 1

# Test removal
am --system
am -r zsync2

# Check for errors
am -f > .results
_check_count .results zsync2 0

# Pass the test if all was good
echo "Test passed!"

