#!/bin/bash

# check executables
checkExecutable "iObserve Adaptation" "$ADAPTATION_EXECUTABLE"

# check for directories
checkDirectory "Adaptation working directory" $WORKING_DIR_ADAPTATION

# check for files
checkFile "Adaptation config" $WORKING_DIR_ADAPTATION/adaptation.config


# start service
echo "Starting adaptation..."

$ADAPTATION_EXECUTABLE -c $WORKING_DIR_ADAPTATION/adaptation.config &

echo "Adaptation terminated."