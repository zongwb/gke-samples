#!/usr/bin/env bash

# Bash safeties: exit on error, no unset variables, pipelines can't hide errors
set -o errexit
set -o nounset
set -o pipefail

cd "$(dirname "$0")"


: "$PROJECT_ID"
: "$REGION"
: "$CLUSTER_NAME"
: "$K8S_SA"
: "$APP_SA_NAME"
APP_SA_FULL=${APP_SA_NAME}@${PROJECT_ID}.iam.gserviceaccount.com
K8S_NS=db-demo

gcloud container clusters get-credentials $CLUSTER_NAME --region $REGION --project $PROJECT_ID
kubectl create namespace $K8S_NS --dry-run=client -o yaml | kubectl apply -f -

echo "Creating SA $K8S_SA in namespace $K8S_NS"
kubectl create serviceaccount -n $K8S_NS $K8S_SA --dry-run=client -o yaml | kubectl apply -f -

echo "Adding IAM binding for $K8S_SA to $APP_SA_FULL"
gcloud iam service-accounts add-iam-policy-binding \
	$APP_SA_FULL \
	--role roles/iam.workloadIdentityUser \
	--member serviceAccount:$PROJECT_ID.svc.id.goog[$K8S_NS/$K8S_SA] \
	--condition=None

echo "Adding annotation for $K8S_SA"
kubectl annotate serviceaccount -n $K8S_NS $K8S_SA \
  iam.gke.io/gcp-service-account=$APP_SA_FULL
