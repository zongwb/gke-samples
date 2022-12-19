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
envsubst '$BASE_DOMAIN $OLD_DOMAIN $APP_SVC_NAME' < app-ingress.yaml | kubectl apply -n $K8S_NS -f -

echo "Checking the status"
kubectl -n ingress-controller get all
kubectl get ingress -n $K8S_NS
