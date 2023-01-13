#!/usr/bin/env bash

# Bash safeties: exit on error, no unset variables, pipelines can't hide errors
set -o errexit
set -o nounset
set -o pipefail

cd "$(dirname "$0")"

: "$PROJECT_ID"
: "$REGION"
: "$CLUSTER_NAME"
: "$KEY_RING"
: "$KEY_CMEK_DISK"
: "$GKE_NODES_MAX"
: "$MACHINE_TYPE"
: "$DISK_TYPE"
: "$DISK_SIZE_GB"
: "$GKE_NODE_SA_NAME"


echo "Creating GKE cluster $CLUSTER_NAME"

gcloud beta container node-pools create $NODE_POOL \
  --cluster=$CLUSTER_NAME \
  --region $REGION \
  --boot-disk-kms-key projects/$PROJECT_ID/locations/$REGION/keyRings/$KEY_RING/cryptoKeys/$KEY_CMEK_DISK \
  --shielded-secure-boot \
  --shielded-integrity-monitoring \
  --enable-autoscaling \
  --node-labels node=sample-app \
  --max-nodes $GKE_NODES_MAX \
  --num-nodes 1 \
  --workload-metadata GKE_METADATA \
  --service-account "$GKE_NODE_SA_NAME@$PROJECT_ID.iam.gserviceaccount.com" \
  --metadata enable-os-login=TRUE \
  --machine-type $MACHINE_TYPE \
  --image-type COS_CONTAINERD \
  --disk-size $DISK_SIZE_GB \
  --disk-type $DISK_TYPE \
  --verbosity=debug
 