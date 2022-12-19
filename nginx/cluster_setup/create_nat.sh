#!/usr/bin/env bash

# Bash safeties: exit on error, no unset variables, pipelines can't hide errors
set -o errexit
set -o nounset
set -o pipefail

cd "$(dirname "$0")"

: "$PROJECT_ID"
: "$REGION"
: "$NETWORK"
: "$NAT_GW"
: "$NAT_ROUTER"

echo "Creating the router"
if ! gcloud compute routers describe $NAT_ROUTER --region $REGION --project $PROJECT_ID; then
    echo "Router $NAT_ROUTER not found, creating it now..."
    gcloud compute routers create $NAT_ROUTER \
    --project $PROJECT_ID \
    --network $NETWORK \
    --region $REGION
fi

echo "Creating the NAT"
if ! gcloud compute routers nats describe $NAT_GW --router $NAT_ROUTER --region $REGION --project $PROJECT_ID; then
    echo "NAT $NAT_GW not found, creating it now..."
    gcloud compute routers nats create $NAT_GW \
    --project $PROJECT_ID \
    --router $NAT_ROUTER \
    --auto-allocate-nat-external-ips \
    --nat-all-subnet-ip-ranges \
    --enable-logging \
    --region $REGION
fi
