#!/bin/bash

set -aueo pipefail
source .env

DEMO_NAMESPACE="${DEMO_NAMESPACE}"

# Create namespace
kubectl create namespace "$DEMO_NAMESPACE" --save-config