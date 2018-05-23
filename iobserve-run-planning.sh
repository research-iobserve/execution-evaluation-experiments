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

# check for directories
checkDirectory "Planning working directory" $WORKING_DIR_PLANNING
checkDirectory "Initial runtime model" $WORKING_DIR_PLANNING/runtimemodel
checkDirectory "Initial redeployment model" $WORKING_DIR_PLANNING/redeploymentmodel

# check for files
checkFile "Planning config" $WORKING_DIR_PLANNING/planning.config


# start service
echo "Starting planning..."

$PLANNING_EXECUTABLE -c $WORKING_DIR_PLANNING/planning.config &

echo "Planning terminated."