#!/bin/bash

set -aueo pipefail

# shellcheck disable=SC1091
source .env

TEST_NAMESPACE="${DEMO_NAMESPACE:-dapr-test}"

helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update
helm upgrade --install redis bitnami/redis -n $TEST_NAMESPACE

