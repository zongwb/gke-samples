#!/usr/bin/env bash

# Bash safeties: exit on error, no unset variables, pipelines can't hide errors
set -o errexit
set -o nounset
set -o pipefail

cd "$(dirname "$0")"

: "$PROJECT_ID"
: "$CLUSTER_NAME"
: "$SQL_INSTANCE_NAME"
: "$RECORD_PREFIX"
: "$REGION"
: "$ZONE_NAME"
: "$DNS_SUFFIX"

export IP_ADDR=$(yes | gcloud beta sql instances list --filter=name:$SQL_INSTANCE_NAME --format="value(PRIVATE_ADDRESS)")
echo "Database's IP is $IP_ADDR"

RECORD_NAME="$RECORD_PREFIX.$DNS_SUFFIX"

gcloud container clusters get-credentials $CLUSTER_NAME --region $REGION --project $PROJECT_ID

echo "Adding the DNS record $RECORD_NAME : $IP_ADDR"
gcloud dns record-sets transaction start \
    --project $PROJECT_ID \
    --zone $ZONE_NAME

gcloud dns record-sets transaction add $IP_ADDR \
    --project $PROJECT_ID \
    --name $RECORD_NAME \
    --ttl=60 --type=A \
    --zone $ZONE_NAME

gcloud dns record-sets transaction execute \
    --project $PROJECT_ID \
    --zone $ZONE_NAME
