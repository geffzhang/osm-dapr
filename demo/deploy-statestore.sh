#!/bin/bash

set -aueo pipefail

# shellcheck disable=SC1091
source .env

REDIS_PASSWORD=$(kubectl get secret --namespace default redis -o jsonpath="{.data.redis-password}" | base64 -d)

kubectl create secret generic redis --from-literal=redisPassword=$REDIS_PASSWORD -n $DEMO_NAMESPACE

kubectl apply -f - <<EOF
apiVersion: dapr.io/v1alpha1
kind: Component
metadata:
  name: statestore
  namespace: $DEMO_NAMESPACE
spec:
  type: state.redis
  version: v1
  metadata:
  - name: redisHost
    value: redis-master.default.svc.cluster.local:6379
  - name: redisPassword
    secretKeyRef:
      name: redis
      key: redisPassword
auth:
  secretStore: kubernetes
EOF