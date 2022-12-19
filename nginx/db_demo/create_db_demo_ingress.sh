#!/usr/bin/env bash

# Bash safeties: exit on error, no unset variables, pipelines can't hide errors
set -o errexit
set -o nounset
set -o pipefail

cd "$(dirname "$0")"

: "$BASE_DOMAIN"
: "$OLD_DOMAIN"


echo "Installing the app's ingress"
kubectl create namespace db-demo --dry-run=client -o yaml | kubectl apply -f -
envsubst '$BASE_DOMAIN $OLD_DOMAIN' < db-demo-ingress.yaml | kubectl apply -n db-demo -f -

echo "Checking the status"
kubectl -n ingress-controller get all
kubectl get ingress -n db-demo
