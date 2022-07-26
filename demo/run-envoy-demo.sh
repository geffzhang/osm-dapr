#!/bin/bash

set -aueo pipefail
source .env

K8S_NAMESPACE="${K8S_NAMESPACE:-osm-system}"
MESH_NAME="${MESH_NAME:-osm}"
IMAGE_PULL_POLICY="${IMAGE_PULL_POLICY:-IfNotPresent}"
SIDECAR_LOG_LEVEL="${SIDECAR_LOG_LEVEL:-error}"
TIMEOUT="${TIMEOUT:-300s}"
ARCH=$(dpkg --print-architecture)

# clean up
./demo/clean-kubernetes.sh

# delete previous download
rm -rf ./Linux-$ARCH ./linux-$ARCH


release=v1.1.0
curl -sL https://github.com/openservicemesh/osm/releases/download/${release}/osm-${release}-linux-$ARCH.tar.gz | tar -vxzf -
cp ./linux-$ARCH/osm /usr/local/bin/osm

# install dapr cli 
wget -q https://raw.githubusercontent.com/dapr/cli/master/install/install.sh -O - | /bin/bash


# install dapr 
dapr init --kubernetes --enable-mtls=false 

# install osm cli
osm install \
    --mesh-name "$MESH_NAME" \
    --osm-namespace "$K8S_NAMESPACE" \
    --verbose \
    --set=osm.enablePermissiveTrafficPolicy=true \
    --set=osm.enableDebugServer="false" \
    --set=osm.enableEgress="false" \
    --set=osm.enableReconciler="false" \
    --set=osm.deployGrafana="false" \
    --set=osm.deployJaeger="false" \
    --set=osm.tracing.enable="false" \
    --set=osm.enableFluentbit="false" \
    --set=osm.deployPrometheus="false" \
    --set=osm.controllerLogLevel="trace" \
    --set=contour.enabled="true" \
    --set=contour.configInline.tls.envoy-client-certificate.name="osm-contour-envoy-client-cert" \
    --set=contour.configInline.tls.envoy-client-certificate.namespace="$K8S_NAMESPACE" \
    --timeout="$TIMEOUT"    

# install redis 
./demo/deploy-redis.sh

# enable permissive traffic mode
./scripts/mesh-enable-permissive-traffic-mode.sh
# exclude eureka, config server port from sidecar traffic intercept
./scripts/mesh-port-exclusion.sh
# change cpu limit of sidecar resources
./scripts/mesh-sidecar-resources.sh
# create app namespace
./demo/create-app-namespace.sh
# create role get secret Non-default namespaces 
./demo/configure-app-rolebinding.sh
# config app namespace and involve it in mesh
./demo/configure-app-namespace.sh
# create dapr config
./demo/create-daprconfig.sh
# deploy app
./demo/deploy-app.sh
# deploy ingress
 ./demo/deploy-ingress-contour.sh