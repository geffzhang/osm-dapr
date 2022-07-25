#!/bin/bash

set -aueo pipefail
source .env

./demo/deploy-statestore.sh;
./demo/deploy-nodeapp.sh;
./demo/deploy-pythonapp.sh; 
