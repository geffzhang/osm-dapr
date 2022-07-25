#!/bin/bash

set -aueo pipefail

# shellcheck disable=SC1091
source .env

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
    value: redis-master.$DEMO_NAMESPACE.svc.cluster.local:6379
  - name: redisPassword
    secretKeyRef:
      name: redis
      key: redis-password
auth:
  secretStore: kubernetes
EOF