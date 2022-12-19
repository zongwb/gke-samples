#!/usr/bin/env bash

# Bash safeties: exit on error, no unset variables, pipelines can't hide errors
set -o errexit
set -o nounset
set -o pipefail

cd "$(dirname "$0")"

: "$PROJECT_ID"
: "$NETWORK"
: "$ZONE_NAME"
: "$DNS_SUFFIX"

echo "Creating the DNS zone"
gcloud beta dns managed-zones create $ZONE_NAME \
    --project $PROJECT_ID \
    --description "App internal DNS" \
    --dns-name $DNS_SUFFIX \
    --networks $NETWORK \
    --visibility private \
    --quiet
