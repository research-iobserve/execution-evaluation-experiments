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
checkDirectory "Kubernetes configuration directory" $KUBERNETES_DIR
checkDirectory "iObserve configuration directory" $IOBSERVE_DIR
checkDirectory "Scenario directory" $SCENARIO_DIR
checkDirectory "Concrete scenario directory" $SCENARIO_DIR/$SCENARIO
checkDirectory "Runtime model directory" $SCENARIO_DIR/$SCENARIO/runtimemodel
checkDirectory "Redeployment model directory" $SCENARIO_DIR/$SCENARIO/redeploymentmodel
checkDirectory "Planning working directory" $WORKING_DIR_PLANNING
checkDirectory "Adaptation working directory" $WORKING_DIR_ADAPTATION
checkDirectory "Execution working directory" $WORKING_DIR_EXECUTION

echo "Setting up iObserve workspaces..."

# clear working directories
rm -rf $WORKING_DIR_PLANNING/*
rm -rf $WORKING_DIR_ADAPTATION/*
rm -rf $WORKING_DIR_EXECUTION/*

# copy models to working directory of planning
cp -R $SCENARIO_DIR/$SCENARIO/runtimemodel $WORKING_DIR_PLANNING
cp -R $SCENARIO_DIR/$SCENARIO/redeploymentmodel $WORKING_DIR_PLANNING

# copy correspondence model to working directory of execution
cp $SCENARIO_DIR/execution-example.correspondencemodel $WORKING_DIR_EXECUTION

# copy iobserve configuration files to working dirs and replace paths in iobserve configuration files
cat $IOBSERVE_DIR/planning.config | sed "s#%WORKING_DIRECTORY_PLANNING%#$WORKING_DIR_PLANNING#g" > $WORKING_DIR_PLANNING/planning.config
cat $IOBSERVE_DIR/adaptation.config | sed "s#%WORKING_DIRECTORY_ADAPTATION%#$WORKING_DIR_ADAPTATION#g" > $WORKING_DIR_ADAPTATION/adaptation.config
cat $IOBSERVE_DIR/execution.config | sed "s#%WORKING_DIRECTORY_EXECUTION%#$WORKING_DIR_EXECUTION#g" > $WORKING_DIR_EXECUTION/execution.config

# replace PlanningMain by PlanningMainMockup in execution script to exclude model optimization with PerOpteryx from planning
TEMP="${PLANNING_EXECUTABLE}2" # (workaround because sed -i did not work in the test environment)
cat $PLANNING_EXECUTABLE | sed "s#PlanningMain #PlanningMainMockup #g" > $TEMP
mv $TEMP $PLANNING_EXECUTABLE
chmod 700 $PLANNING_EXECUTABLE

echo "Done."