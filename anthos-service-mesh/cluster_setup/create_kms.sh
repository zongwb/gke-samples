#!/usr/bin/env bash

# Bash safeties: exit on error, no unset variables, pipelines can't hide errors
set -o errexit
set -o nounset
set -o pipefail

cd "$(dirname "$0")"

: "$PROJECT_ID"
: "$REGION"
: "$KEY_RING"
: "$KEY_CMEK_DISK"
: "$KEY_CMEK_GKE"

echo "Creating the KMS key ring and keys"
gcloud kms keyrings create $KEY_RING \
    --location $REGION

gcloud kms keys create $KEY_CMEK_DISK \
    --project $PROJECT_ID \
    --keyring $KEY_RING \
    --location $REGION \
    --purpose "encryption" \
    --rotation-period 60d \
    --next-rotation-time "2023-09-16T01:02:03"

gcloud kms keys create $KEY_CMEK_DB \
    --project $PROJECT_ID \
    --keyring $KEY_RING \
    --location $REGION \
    --purpose "encryption" \
    --rotation-period 60d \
    --next-rotation-time "2023-09-16T01:02:03"

gcloud kms keys create $KEY_CMEK_GKE \
    --project $PROJECT_ID \
    --keyring $KEY_RING \
    --location $REGION \
    --purpose "encryption" \
    --rotation-period 60d \
    --next-rotation-time "2023-09-16T01:02:03"

echo "Granting necessary permissions"
gcloud kms keys add-iam-policy-binding $KEY_CMEK_DISK \
    --location $REGION \
    --keyring $KEY_RING \
    --member serviceAccount:$PROJECT_NUMBER-compute@developer.gserviceaccount.com \
    --role roles/cloudkms.cryptoKeyEncrypterDecrypter \
    --project $PROJECT_ID \
    --condition=None

gcloud kms keys add-iam-policy-binding $KEY_CMEK_DISK \
    --location $REGION \
    --keyring $KEY_RING \
    --member serviceAccount:service-$PROJECT_NUMBER@container-engine-robot.iam.gserviceaccount.com \
    --role roles/cloudkms.cryptoKeyEncrypterDecrypter \
    --project $PROJECT_ID \
    --condition=None

gcloud kms keys add-iam-policy-binding $KEY_CMEK_DISK \
    --location $REGION \
    --keyring $KEY_RING \
    --member serviceAccount:service-$PROJECT_NUMBER@compute-system.iam.gserviceaccount.com \
    --role roles/cloudkms.cryptoKeyEncrypterDecrypter \
    --project $PROJECT_ID \
    --condition=None

gcloud kms keys add-iam-policy-binding $KEY_CMEK_DB \
    --location $REGION \
    --keyring $KEY_RING \
    --member serviceAccount:service-$PROJECT_NUMBER@container-engine-robot.iam.gserviceaccount.com \
    --role roles/cloudkms.cryptoKeyEncrypterDecrypter \
    --project $PROJECT_ID \
    --condition=None

gcloud kms keys add-iam-policy-binding $KEY_CMEK_GKE \
    --location $REGION \
    --keyring $KEY_RING \
    --member serviceAccount:service-$PROJECT_NUMBER@container-engine-robot.iam.gserviceaccount.com \
    --role roles/cloudkms.cryptoKeyEncrypterDecrypter \
    --project $PROJECT_ID \
    --condition=None