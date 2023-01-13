#!/usr/bin/env bash

# Bash safeties: exit on error, no unset variables, pipelines can't hide errors
set -o errexit
set -o nounset
set -o pipefail

cd "$(dirname "$0")"

: "$PROJECT_ID"
: "$REGION"
: "$NETWORK"
SUBNET=$NETWORK

if ! gcloud compute networks describe $NETWORK --project $PROJECT_ID; then    
    echo "Network $NETWORK not found, creating it now..."
    gcloud compute networks create $NETWORK \
    --project $PROJECT_ID \
    --subnet-mode auto \
    --bgp-routing-mode regional
fi

echo "Checking default rules"
if ! gcloud compute firewall-rules describe app-allow-https --project $PROJECT_ID; then
    echo "firewall-rules app-allow-https not found, adding it now..."
    gcloud compute firewall-rules create app-allow-https --network $NETWORK \
    --project $PROJECT_ID \
    --priority 1000 --action allow --direction ingress \
    --source-ranges 0.0.0.0/0 \
    --rules tcp:443 \
    --target-tags https-server
fi

if ! gcloud compute firewall-rules describe app-allow-internal --project $PROJECT_ID; then
    echo "firewall-rules app-allow-internal not found, adding it now..."
    gcloud compute firewall-rules create app-allow-internal --network $NETWORK \
    --project $PROJECT_ID \
    --priority 65534 --action allow --direction ingress \
    --source-ranges 10.128.0.0/9 \
    --rules tcp:0-65535,udp:0-65535,icmp
fi
