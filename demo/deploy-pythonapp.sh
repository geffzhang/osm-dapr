#!/bin/bash

set -aueo pipefail

# shellcheck disable=SC1091
source .env

kubectl apply -f - <<EOF
apiVersion: apps/v1
kind: Deployment
metadata:
  name: pythonapp
  namespace: $DEMO_NAMESPACE
  labels:
    app: python
spec:
  replicas: 1
  selector:
    matchLabels:
      app: python
  template:
    metadata:
      labels:
        app: python
      annotations:
        dapr.io/enabled: "true"
        dapr.io/app-id: "pythonapp"
        dapr.io/enable-api-logging: "true"
        dapr.io/config: "appconfig"
        openservicemesh.io/outbound-port-exclusion-list: "80"
    spec:
      containers:
      - name: python
        image: ghcr.io/dapr/samples/hello-k8s-python:latest
EOF