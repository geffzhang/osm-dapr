#!/bin/bash

set -aueo pipefail

# shellcheck disable=SC1091
source .env

TIMEOUT="${TIMEOUT:-90s}"

# uninstall ingress nginx
nginx_ingress_namespace="ingress-nginx"
helm uninstall ingress-nginx -n "$nginx_ingress_namespace" || true

# uninstall redis
helm uninstall redis || true
# delete demo namespace
kubectl delete ns "$DEMO_NAMESPACE" || true
# uninstall dapr
dapr uninstall --kubernetes || true
# uninstall osm
osm uninstall mesh -f --mesh-name "$MESH_NAME" --osm-namespace "$K8S_NAMESPACE" --delete-namespace -a || true

wait
