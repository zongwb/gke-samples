#!/usr/bin/env bash

# Bash safeties: exit on error, no unset variables, pipelines can't hide errors
set -o errexit
set -o nounset
set -o pipefail

cd "$(dirname "$0")"

: "$PROJECT_ID"
: "$REGION"
: "$CLUSTER_NAME"
: "$BASE_DOMAIN"
: "$OLD_DOMAIN"
: "$APP_SVC_NAME"

echo "Installing helm"
curl https://raw.githubusercontent.com/helm/helm/v3.9.2/scripts/get-helm-3 | bash

if ! command -v envsubst &> /dev/null
then
    echo "Installing envsubst"
	apt-get update -y && apt-get -y install gettext-base
fi


gcloud container clusters get-credentials $CLUSTER_NAME --region $REGION --project $PROJECT_ID
echo "Testing kubectl"
kubectl get namespaces

echo "Installing nginx controller"
helm repo add jetstack https://charts.jetstack.io
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update
helm delete nginx || echo "No chart named nginx; proceed"
kubectl create namespace ingress-controller --dry-run=client -o yaml | kubectl apply -f -
helm upgrade --install nginx ingress-nginx/ingress-nginx \
	-n ingress-controller \
    --version 4.4.0

echo "Installing cert manager"
kubectl create namespace cert-manager --dry-run=client -o yaml | kubectl apply -f -
helm upgrade --install cert-manager jetstack/cert-manager \
    --namespace cert-manager \
    --version v1.10.0 \
    --set installCRDs=true
# # WTF hack!!! Must wait a while for the cert-manager to get ready; else the subsequent install will fail!
sleep 30
# # Also need to disable the validation: https://github.com/kubernetes/ingress-nginx/issues/5401
kubectl delete -A ValidatingWebhookConfiguration nginx-ingress-nginx-admission -n ingress-controller

echo "Installing ClusterIssuer"
envsubst < letsencrypt-issuer.yaml | kubectl apply -f - -n cert-manager

echo "Checking the status"
kubectl get all -n cert-manager
kubectl -n ingress-controller get all

echo "**Wait for the IP to be assigned and update AWS Route53 record.**"
