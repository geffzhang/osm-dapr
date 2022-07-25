#!/bin/bash

set -aueo pipefail
source .env
./demo/deploy-statestore.sh;
./demo/deploy-redis.sh;
./demo/deploy-nodeapp.sh;
./demo/deploy-pythonapp.sh; 

sleep 5
kubectl wait --namespace $DEMO_NAMESPACE \
  --for=condition=ready pod \
  --selector=type=app \
  --timeout=600s