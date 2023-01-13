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


echo "Enable Flow Logs and Private Google access"
gcloud compute networks subnets update $SUBNET --enable-private-ip-google-access --region $REGION --project $PROJECT_ID;
gcloud compute networks subnets update $SUBNET --enable-flow-logs --region $REGION;

# Hackish: By default the 'subnet' has the same name as 'network'
export regions=$(gcloud compute networks subnets list | awk '{print $2}' | grep -v REGION | tr '\n' ' ')
for r in $regions
do
    gcloud compute networks subnets update $NETWORK --enable-private-ip-google-access --region $r;
    gcloud compute networks subnets update $NETWORK --enable-flow-logs --region $r;
done
