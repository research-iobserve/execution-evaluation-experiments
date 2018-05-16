#!/bin/bash

# execute setup

BASE_DIR=$(cd "$(dirname "$0")"; pwd)

if [ -f $BASE_DIR/config ] ; then
	. $BASE_DIR/config
else
	echo "Missing configuration"
	exit 1
fi

# shutdown jpetstore
echo "<<<<<<<<<<< term jpetstore"

kubectl delete --grace-period=60 service/jpetstore
for I in frontend account catalog order ; do
	kubectl delete --grace-period=120 pods/$I
done

sleep 120

# shutdown analysis/collector
echo "<<<<<<<<<<< term analysis"

kill -TERM ${COLLECTOR_PID}
rm collector.config

echo "Done."
# end