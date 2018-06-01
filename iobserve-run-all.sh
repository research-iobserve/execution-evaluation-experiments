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
checkExecutable "iObserve Planning" "$PLANNING_EXECUTABLE"
checkExecutable "iObserve Adaptation" "$ADAPTATION_EXECUTABLE"
checkExecutable "iObserve Execution" "$EXECUTION_EXECUTABLE"

# check for directories
checkDirectory "Planning working directory" $WORKING_DIR_PLANNING
checkDirectory "Initial runtime model" $WORKING_DIR_PLANNING/runtimemodel
checkDirectory "Initial redeployment model" $WORKING_DIR_PLANNING/redeploymentmodel
checkDirectory "Adaptation working directory" $WORKING_DIR_ADAPTATION
checkDirectory "Execution working directory" $WORKING_DIR_EXECUTION

# check for files
checkFile "Planning config" $WORKING_DIR_PLANNING/planning.config
checkFile "Adaptation config" $WORKING_DIR_ADAPTATION/adaptation.config
checkFile "Execution config" $WORKING_DIR_EXECUTION/execution.config
checkFile "Correspondence model" $WORKING_DIR_EXECUTION/execution-example.correspondencemodel


# start services
echo "Starting execution..."
$EXECUTION_EXECUTABLE -c $WORKING_DIR_EXECUTION/execution.config & 
PID1=$!

sleep 15 

echo "Starting adaptation..."
$ADAPTATION_EXECUTABLE -c $WORKING_DIR_ADAPTATION/adaptation.config &
PID2=$!

sleep 15

echo "Starting planning..."
$PLANNING_EXECUTABLE -c $WORKING_DIR_PLANNING/planning.config &

sleep 30

# stop services 
echo "Terminating..."

kill $PID2
kill $PID1

echo "iObserve terminated."