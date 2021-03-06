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
for I in frontend account account2 catalog order ; do
	kubectl delete --grace-period=120 deployments/$I
done

echo "Done."
# end
