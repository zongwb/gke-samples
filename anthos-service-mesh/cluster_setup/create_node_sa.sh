#!/usr/bin/env bash

# Bash safeties: exit on error, no unset variables, pipelines can't hide errors
set -o errexit
set -o nounset
set -o pipefail

cd "$(dirname "$0")"

: "$PROJECT_ID"
: "$PROJECT_NUMBER"
: "$GKE_NODE_SA_NAME"
GKE_NODE_SA_FULL=${GKE_NODE_SA_NAME}@${PROJECT_ID}.iam.gserviceaccount.com

echo "Creating service account $GKE_NODE_SA_FULL"

gcloud iam service-accounts create "$GKE_NODE_SA_NAME" \
    --project $PROJECT_ID \
    --display-name "$GKE_NODE_SA_NAME"

gcloud projects add-iam-policy-binding $PROJECT_ID \
    --member serviceAccount:"$GKE_NODE_SA_FULL" \
    --role roles/logging.logWriter \
    --condition=None

gcloud projects add-iam-policy-binding $PROJECT_ID \
    --member serviceAccount:"$GKE_NODE_SA_FULL" \
    --role roles/monitoring.metricWriter \
    --condition=None

gcloud projects add-iam-policy-binding $PROJECT_ID \
    --member serviceAccount:"$GKE_NODE_SA_FULL" \
    --role roles/monitoring.viewer \
    --condition=None

gcloud projects add-iam-policy-binding $PROJECT_ID \
    --member serviceAccount:"$GKE_NODE_SA_FULL" \
    --role roles/storage.objectViewer \
    --condition=None

echo "Grant cloudbuild serviceaccount permission to act as $GKE_NODE_SA_NAME"
gcloud iam service-accounts add-iam-policy-binding \
    $GKE_NODE_SA_FULL \
    --member serviceAccount:$PROJECT_NUMBER@cloudbuild.gserviceaccount.com \
    --role roles/iam.serviceAccountUser \
    --condition=None
