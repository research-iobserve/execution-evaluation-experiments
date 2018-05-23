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
checkDirectory "iObserve configuration directory" $IOBSERVE_DIR
checkDirectory "Scenario directory" $SCENARIO_DIR
checkDirectory "Concrete scenario directory" $SCENARIO_DIR/$SCENARIO
checkDirectory "Runtime model directory" $SCENARIO_DIR/$SCENARIO/runtimemodel
checkDirectory "Redeployment model directory" $SCENARIO_DIR/$SCENARIO/redeploymentmodel
checkDirectory "Planning working directory" $WORKING_DIR_PLANNING


echo "Setting up iObserve planning workspace..."

# clear working directories
rm -rf $WORKING_DIR_PLANNING/*

# copy models to working directory of planning
cp -R $SCENARIO_DIR/$SCENARIO/runtimemodel $WORKING_DIR_PLANNING
cp -R $SCENARIO_DIR/$SCENARIO/redeploymentmodel $WORKING_DIR_PLANNING


# copy iobserve planning configuration file to working dir and replace paths in iobserve configuration file
cat $IOBSERVE_DIR/planning.config | sed "s#%WORKING_DIRECTORY_PLANNING%#$WORKING_DIR_PLANNING#g" > $WORKING_DIR_PLANNING/planning.config

# replace PlanningMain by PlanningMainMockup in execution script to exclude model optimization with PerOpteryx from planning
TEMP="${PLANNING_EXECUTABLE}2" # (workaround because sed -i did not work in the test environment)
cat $PLANNING_EXECUTABLE | sed "s#PlanningMain #PlanningMainMockup #g" > $TEMP
mv $TEMP $PLANNING_EXECUTABLE
chmod 700 $PLANNING_EXECUTABLE

echo "Done."