#!/usr/bin/env bash

# Bash safeties: exit on error, no unset variables, pipelines can't hide errors
set -o errexit
set -o nounset
set -o pipefail

cd "$(dirname "$0")"

: "$BASE_DOMAIN"
: "$OLD_DOMAIN"
: "$APP_SVC_NAME"
K8S_NS=frontend

echo "Installing the app's ingress"
kubectl create namespace $K8S_NS --dry-run=client -o yaml | kubectl apply -f -
for ns in ad cart checkout currency email frontend loadgenerator payment product-catalog recommendation shipping; do
  kubectl label namespace $ns istio-injection=enabled istio.io/rev- --overwrite
done;

envsubst < app-virtualservice.yaml | kubectl apply  -f -