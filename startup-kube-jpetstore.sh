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

# check for directories
checkDirectory "Kubernetes" $KUBERNETES_DIR


#############################################
# check if no leftovers are running

# check all kubernetes services of the experiment are terminated
kubectl delete service/jpetstore
for I in frontend account account2 catalog order ; do
	kubectl delete deployments/$I
done

#####################################################################
# starting jpetstore

echo ">>>>>>>>>>> start jpetstore"

# initialize different deployments depending on the scenario
# only on resource container for account so far
if [ $SCENARIO = "migration" ]; then
  cat $KUBERNETES_DIR/migration/jpetstore.yaml | sed "s/%LOGGER%/$LOGGER/g" > start.yaml
# two resource containers for account but one without a deployed instance so far
elif [ $SCENARIO = "replication" ]; then
  cat $KUBERNETES_DIR/replication/jpetstore.yaml | sed "s/%LOGGER%/$LOGGER/g" > start.yaml
# two resource containers for account both with a deployed instance
elif [ $SCENARIO = "dereplication" ]; then
  cat $KUBERNETES_DIR/dereplication/jpetstore.yaml | sed "s/%LOGGER%/$LOGGER/g" > start.yaml
fi
kubectl create -f start.yaml

rm start.yaml

FRONTEND=""
while [ "$FRONTEND" == "" ] ; do
	ID=`kubectl get pods | grep frontend | awk '{ print $1 }'`
	FRONTEND=`kubectl describe pods/$ID | grep "IP:" | awk '{ print $2 }'`
done

SERVICE_URL="http://$FRONTEND:8080/jpetstore-frontend"

echo "Servie URL $SERVICE_URL"

while ! curl -sSf $SERVICE_URL ; do
	sleep 1
done

echo "Done."
# end