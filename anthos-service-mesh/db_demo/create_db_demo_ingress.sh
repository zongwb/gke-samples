#!/usr/bin/env bash

# Bash safeties: exit on error, no unset variables, pipelines can't hide errors
set -o errexit
set -o nounset
set -o pipefail

cd "$(dirname "$0")"

: "$BASE_DOMAIN"

echo "Installing the app's ingress"
kubectl create namespace $K8S_NS --dry-run=client -o yaml | kubectl apply -f -
kubectl label namespace $K8S_NS istio-injection=enabled istio.io/rev- --overwrite
envsubst < db-demo-virtualservice.yaml | kubectl apply  -f -