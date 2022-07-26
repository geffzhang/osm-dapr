#!/bin/bash

set -aueo pipefail
source .env


kubectl apply -f - <<EOF
---
apiVersion: dapr.io/v1alpha1
kind: Configuration
metadata:
  name: appconfig
  namespace: $DEMO_NAMESPACE
spec:
  tracing:
    samplingRate: "1"
EOF