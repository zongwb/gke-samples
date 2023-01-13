#!/usr/bin/env bash

# Bash safeties: exit on error, no unset variables, pipelines can't hide errors
set -o errexit
set -o nounset
set -o pipefail

cd "$(dirname "$0")"

: "$PROJECT_ID"
: "$REGION"
: "$CLUSTER_NAME"
: "$GKE_VERSION"
: "$KEY_RING"
: "$KEY_CMEK_DISK"
: "$KEY_CMEK_GKE"
: "$GKE_NODES_MAX"
: "$NETWORK"
: "$MASTER_IPV4_CIDR_BLOCK"
: "$MACHINE_TYPE"
: "$DISK_TYPE"
: "$DISK_SIZE_GB"
: "$GKE_NODE_SA_NAME"


echo "Creating GKE cluster $CLUSTER_NAME"

gcloud container clusters create $CLUSTER_NAME \
  --cluster-version $GKE_VERSION \
  --region $REGION \
  --boot-disk-kms-key projects/$PROJECT_ID/locations/$REGION/keyRings/$KEY_RING/cryptoKeys/$KEY_CMEK_DISK \
  --database-encryption-key projects/$PROJECT_ID/locations/$REGION/keyRings/$KEY_RING/cryptoKeys/$KEY_CMEK_GKE \
  --enable-intra-node-visibility \
  --enable-shielded-nodes \
  --shielded-secure-boot \
  --shielded-integrity-monitoring \
  --binauthz-evaluation-mode PROJECT_SINGLETON_POLICY_ENFORCE \
  --enable-autoscaling \
  --enable-vertical-pod-autoscaling \
  --labels node=$CLUSTER_NAME \
  --max-nodes $GKE_NODES_MAX \
  --num-nodes 1 \
  --workload-pool=$PROJECT_ID.svc.id.goog \
  --workload-metadata GKE_METADATA \
  --network $NETWORK \
  --enable-network-policy \
  --no-enable-master-authorized-networks  \
  --enable-ip-alias \
  --enable-private-nodes \
  --master-ipv4-cidr $MASTER_IPV4_CIDR_BLOCK \
  --monitoring=SYSTEM,API_SERVER,CONTROLLER_MANAGER,SCHEDULER \
  --logging=SYSTEM,WORKLOAD \
  --release-channel stable \
  --service-account "$GKE_NODE_SA_NAME@$PROJECT_ID.iam.gserviceaccount.com" \
  --metadata enable-os-login=TRUE \
  --machine-type $MACHINE_TYPE \
  --image-type COS_CONTAINERD \
  --disk-size $DISK_SIZE_GB \
  --disk-type $DISK_TYPE \
  --autoscaling-profile optimize-utilization \
  --labels "mesh_id=proj-$PROJECT_NUMBER"

