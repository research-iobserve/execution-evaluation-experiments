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


# check adaptation
checkExecutable "iObserve Adaptation" "$ADAPTATION"

# check execution
checkExecutable "iObserve Execution" "$EXECUTION"

# check for directories
checkDirectory "Kubernetes" $KUBERNETES_DIR
checkDirectory "Tools" $TOOLS_DIR


#############################################
# check if no leftovers are running

# check all kubernetes services of the experiment are terminated
kubectl delete service/jpetstore
for I in frontend account catalog order ; do
	kubectl delete pods/$I
done

#####################################################################
# starting jpetstore

echo ">>>>>>>>>>> start jpetstore"

cat $KUBERNETES_DIR/jpetstore2.yaml | sed "s/%LOGGER%/$LOGGER/g" > start.yaml
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