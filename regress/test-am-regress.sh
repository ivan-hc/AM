#!/usr/bin/env sh

# Source common test functions
. "$(dirname "$0")/test-common.sh"

# Setup
rm -f $TEST_LOG
_log "Regression testing setup:"
_restore_binaries "$AM_OPT_DEPS"
_remove_all_apps
am --system
am clean
_log "Done.\n"

# Run all regression tests
./test-am-hide.sh
./test-am-install.sh
./test-am-checksum.sh
./test-am-repair.sh
./test-am-sandbox.sh
./test-am-nolibfuse.sh
./test-am-rollback.sh
./test-am-clone.sh
./test-am-utils.sh

# Done
_log "Regression testing complete:"
if grep -q "Test failed!\|ERROR\|Error" < "$TEST_LOG"; then
	_log "Errors detected, please see results in $TEST_LOG\n"
else
	_log "All tests passed!\n"
fi

