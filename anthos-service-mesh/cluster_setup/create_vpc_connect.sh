#!/usr/bin/env bash

# Bash safeties: exit on error, no unset variables, pipelines can't hide errors
set -o errexit
set -o nounset
set -o pipefail

cd "$(dirname "$0")"

: "$PROJECT_ID"
: "$NETWORK"
: "$VPC_CONNECTOR"

gcloud compute networks vpc-access connectors create $VPC_CONNECTOR \
	--project $PROJECT_ID \
    --region asia-southeast2 \
    --network $NETWORK \
    --range 10.8.0.0/28
