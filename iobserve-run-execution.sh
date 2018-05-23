#!/bin/bash

# execute setup
BASE_DIR=$(cd "$(dirname "$0")"; pwd)

if [ -f $BASE_DIR/config ] ; then
	. $BASE_DIR/config
else
	echo "Missing configuration"
	exit 1
fi

. $BASE_DIR/common-functions.sh


# check executables
checkExecutable "iObserve Execution" "$EXECUTION_EXECUTABLE"

# check for directories
checkDirectory "Execution working directory" $WORKING_DIR_EXECUTION

# check for files
checkFile "Execution config" $WORKING_DIR_EXECUTION/execution.config
checkFile "Correspondence model" $WORKING_DIR_EXECUTION/execution-example.correspondencemodel


# start service
echo "Starting execution..."

$EXECUTION_EXECUTABLE -c $WORKING_DIR_EXECUTION/execution.config & 

echo "Execution terminated."