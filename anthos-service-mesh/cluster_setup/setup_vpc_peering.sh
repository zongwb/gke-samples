#!/usr/bin/env bash

# Bash safeties: exit on error, no unset variables, pipelines can't hide errors
set -o errexit
set -o nounset
set -o pipefail

cd "$(dirname "$0")"

: "$PROJECT_ID"
: "$NETWORK"

gcloud compute addresses create google-managed-services-$NETWORK \
    --global \
    --purpose VPC_PEERING \
    --prefix-length 16 \
    --network $NETWORK \
    --project $PROJECT_ID

gcloud services vpc-peerings connect \
    --service servicenetworking.googleapis.com \
    --ranges google-managed-services-$NETWORK \
    --network $NETWORK \
    --project $PROJECT_ID
