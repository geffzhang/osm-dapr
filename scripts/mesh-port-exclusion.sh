#!/bin/bash

# shellcheck disable=SC1091
source .env

K8S_NAMESPACE="${K8S_NAMESPACE}"

if [ "$MESH_ENABLED" = true ]; then
  kubectl patch meshconfig osm-mesh-config -n $K8S_NAMESPACE \ 
    -p '{"spec":{"traffic":{"outboundIPRangeExclusionList":["10.0.0.1/32"]}}}' --type=merge
  kubectl patch meshconfig osm-mesh-config -n $K8S_NAMESPACE \
    -p '{"spec":{"traffic":{"outboundPortExclusionList":[50005,8201,6379]}}}'  --type=merge
fi