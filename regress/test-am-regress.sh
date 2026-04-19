#!/usr/bin/env sh

# Source common test functions
. "$(dirname "$0")/test-common.sh"

# Setup
_log "Running all regression tests:"
rm $TEST_LOG
am --system
am clean

# Run all regression tests
./test-am-checksum.sh
./test-am-hide.sh
./test-am-install.sh

# Done
_log "Regression testing complete!"
echo "Please see results in $TEST_LOG"

