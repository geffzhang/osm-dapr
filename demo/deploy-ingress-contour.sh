#!/bin/bash

set -aueo pipefail

# shellcheck disable=SC1091
source .env

NODEAPP_SERVICE="nodeapp"

kubectl apply -f - <<EOF
apiVersion: projectcontour.io/v1
kind: HTTPProxy
metadata:
  name: basic
  namespace: $DEMO_NAMESPACE
spec:
  virtualhost:
    fqdn: nodeapp.csharpkit.com
  routes:
    - conditions:
      - prefix: /
      services:
        - name: $NODEAPP_SERVICE
          port: 80
EOF


kubectl apply -f - <<EOF
kind: IngressBackend
apiVersion: policy.openservicemesh.io/v1alpha1
metadata:
  name: osm-contour-envoy
  namespace: $DEMO_NAMESPACE
spec:
  backends:
  - name: $NODEAPP_SERVICE
    port:
      number: 80
      protocol: http   
  sources:
  - kind: Service
    namespace: "$K8S_NAMESPACE"
    name: "osm-contour-envoy"
EOF

echo "ingress deployed"