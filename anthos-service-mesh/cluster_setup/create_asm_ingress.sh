#!/usr/bin/env bash

# Bash safeties: exit on error, no unset variables, pipelines can't hide errors
set -o errexit
set -o nounset
set -o pipefail

cd "$(dirname "$0")"

source asm.env

: "$PROJECT_ID"
: "$PROJECT_NUMBER"
: "$REGION"
: "$CLUSTER_NAME"
: "$BASE_DOMAIN"
: "$OLD_DOMAIN"

#### Reference: https://cloud.google.com/architecture/exposing-service-mesh-apps-through-gke-ingress

echo "Enabling Anthos Service Mesh for GKE cluster $CLUSTER_NAME"

#### Enable ASM
gcloud services enable \
    gkehub.googleapis.com \
    mesh.googleapis.com

gcloud container clusters update $CLUSTER_NAME --update-labels "mesh_id=proj-$PROJECT_NUMBER" --region $REGION

gcloud container fleet mesh enable --project $PROJECT_ID

gcloud container fleet memberships register $CLUSTER_NAME-membership \
  --gke-cluster=$REGION/$CLUSTER_NAME \
  --enable-workload-identity \
  --project $PROJECT_ID

gcloud container fleet mesh update \
  --management automatic \
  --memberships $CLUSTER_NAME-membership \
  --project $PROJECT_ID

gcloud container fleet mesh describe --project $PROJECT_ID

#### Create Cloud Armor policy
./asm-ingress/create_security_policy.sh

#### Create a static IP
gcloud compute addresses create $LB_IP_NAME --global

#### Create the ASM ingress namespace
kubectl create ns $INGRESS_NS
kubectl label namespace $INGRESS_NS istio-injection=enabled istio.io/rev- --overwrite

#### Create the TLS b/w the external load balancer and the ASM ingress
./asm-ingress/create_tls.sh

#### Deploy the ASM ingress resources
kubectl apply -f asm-ingress/ingress-serviceaccount.yaml
sleep 10; # Hackish: Pulling the pod images requires the service account to be ready.
kubectl apply -f asm-ingress/ingress-deployment.yaml
#### NOTE: If there's residual from previous istio installaion, may need to delete the injector first
#### kubectl -n default delete  mutatingwebhookconfiguration istio-sidecar-injector
#### NOTE2: If the deployment is not ready after 1 min, try to delete the replica and redeploy.
echo "Waiting for the deployment to be ready..."
kubectl wait --for=condition=available --timeout=60s deployment --all -n $INGRESS_NS
echo "Deployment is ready"
kubectl apply -f asm-ingress/ingress-service.yaml

#### Set up http-2-https redirect and custom headers
export GCLB_IP=$(gcloud compute addresses describe $LB_IP_NAME --global --format "value(address)")
echo ${GCLB_IP}
./asm-ingress/setup_http_redirect.sh


envsubst < asm-ingress/ingress-backendconfig.yaml | kubectl apply -f -
#### NOTE: Update DNS with the GCLB_IP first. The managed certs will take about 15 mins to provision.
envsubst < asm-ingress/managed-cert.yaml | kubectl apply -f -
envsubst < asm-ingress/ingress.yaml | kubectl apply -f -
envsubst < asm-ingress/ingress-gateway.yaml | kubectl apply  -f -
envsubst < asm-ingress/ingress-redirect.yaml | kubectl apply -f -
###: Not needed, but kept as a reference
### envsubst < asm-ingress/ingress-destinationrule.yaml | kubectl apply -f -
### envsubst < asm-ingress/ingress-serviceentry.yaml | kubectl apply -f -

#### Each application should deploy its own ingress rules
echo "The ASM ingress has been installed successfully. For each backend service, you will need to install a VirtualService in its respective namespace to route the traffic."
