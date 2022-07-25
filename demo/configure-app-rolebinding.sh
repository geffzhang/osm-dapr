#!/bin/bash

set -aueo pipefail
source .env

DEMO_NAMESPACE="${DEMO_NAMESPACE}"

kubectl apply -f - <<EOF
---
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: secret-reader
  namespace: $DEMO_NAMESPACE
rules:
- apiGroups: [""]
  resources: ["secrets"]
  verbs: ["get", "list"]
---

kind: RoleBinding
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: dapr-secret-reader
  namespace: $DEMO_NAMESPACE
subjects:
- kind: ServiceAccount
  name: default
roleRef:
  kind: Role
  name: secret-reader
  apiGroup: rbac.authorization.k8s.io
EOF