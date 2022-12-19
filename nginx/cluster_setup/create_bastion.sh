#!/usr/bin/env bash

# Bash safeties: exit on error, no unset variables, pipelines can't hide errors
set -o errexit
set -o nounset
set -o pipefail

cd "$(dirname "$0")"

: "$PROJECT_ID"
: "$BASTION_NAME"
: "$BASTION_MACHINE"
: "$REGION"
: "$KEY_RING"
: "$KEY_CMEK_DISK"
: "$NETWORK"
: "$BASTION_SA"

gcloud beta compute --project=$PROJECT_ID instances create $BASTION_NAME \
    --zone=asia-southeast1-a \
    --machine-type=$BASTION_MACHINE \
    --subnet=$NETWORK --network-tier=PREMIUM \
    --no-address \
    --maintenance-policy=MIGRATE \
    --metadata=block-project-ssh-keys=true \
    --scopes=https://www.googleapis.com/auth/devstorage.read_only,https://www.googleapis.com/auth/logging.write,https://www.googleapis.com/auth/monitoring.write,https://www.googleapis.com/auth/servicecontrol,https://www.googleapis.com/auth/service.management.readonly,https://www.googleapis.com/auth/trace.append \
    --image=debian-10-buster-v20210701 \
    --image-project=debian-cloud \
    --boot-disk-size=10GB \
    --boot-disk-kms-key=projects/$PROJECT_ID/locations/$REGION/keyRings/$KEY_RING/cryptoKeys/$KEY_CMEK_DISK \
    --boot-disk-type=pd-balanced \
    --boot-disk-device-name=$BASTION_NAME \
    --shielded-secure-boot \
    --shielded-vtpm \
    --shielded-integrity-monitoring \
    --reservation-affinity=any \
    --service-account $BASTION_SA

# echo "Creating filewall rule to allow SSH to the internal IP"
# gcloud compute firewall-rules create bastion-allow-ssh --project $PROJECT_ID \
#     --network $NETWORK \
#     --priority 1000 --action allow --direction ingress \
#     --source-ranges 35.235.240.0/20 \
#     --rules tcp:22

### If you need to run Cloudbuild from this VM
# GCB_SA=$PROJECT_NUMBER@cloudbuild.gserviceaccount.com
# gcloud compute instances add-iam-policy-binding $BASTION_NAME \
#     --zone=asia-southeast1-a \
#     --member="serviceAccount:$GCB_SA" \
#     --role="roles/compute.instanceAdmin.v1" \
#     --condition=None

# gcloud projects add-iam-policy-binding $PROJECT_ID \
#     --member="serviceAccount:$GCB_SA" \
#     --role="roles/compute.viewer" \
#     --condition=None

# gcloud projects add-iam-policy-binding $PROJECT_ID \
#     --member="serviceAccount:$GCB_SA" \
#     --role="roles/iam.serviceAccountUser" \
#     --condition=None

# gcloud projects add-iam-policy-binding $PROJECT_ID \
#     --member="serviceAccount:$GCB_SA" \
#     --role="roles/iap.tunnelResourceAccessor" \
#     --condition=None
