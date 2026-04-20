#!/usr/bin/env sh

# Source common test functions
. "$(dirname "$0")/test-common.sh"

# Setup
rm $TEST_LOG
_log "Regression testing setup:"
_remove_all_apps
am --system
am clean
_log "Done.\n"

# Run all regression tests
./test-am-hide.sh
./test-am-install.sh
./test-am-checksum.sh
./test-am-repair.sh

# Done
_log "Regression testing complete!"
echo "Please see results in $TEST_LOG"

