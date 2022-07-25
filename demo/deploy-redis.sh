#!/bin/bash

set -aueo pipefail

# shellcheck disable=SC1091
source .env

helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update
helm upgrade --install redis bitnami/redis 

