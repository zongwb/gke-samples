#!/usr/bin/env bash

# Bash safeties: exit on error, no unset variables, pipelines can't hide errors
set -o errexit
set -o nounset
set -o pipefail

cd "$(dirname "$0")"

: "$PROJECT_ID"
: "$PROJECT_NUMBER"

gcloud projects add-iam-policy-binding $PROJECT_ID \
    --member serviceAccount:$PROJECT_NUMBER@cloudbuild.gserviceaccount.com \
    --role roles/container.admin \
    --condition=None

# gcloud projects add-iam-policy-binding $PROJECT_ID \
#     --member serviceAccount:$PROJECT_NUMBER-compute@developer.gserviceaccount.com \
#     --role roles/container.admin

# gcloud projects add-iam-policy-binding $PROJECT_ID \
#     --member serviceAccount:$PROJECT_NUMBER-compute@developer.gserviceaccount.com \
#     --role roles/cloudkms.admin

# gcloud projects add-iam-policy-binding $PROJECT_ID \
#     --member serviceAccount:$PROJECT_NUMBER-compute@developer.gserviceaccount.com \
#     --role roles/compute.networkAdmin

# gcloud projects add-iam-policy-binding $PROJECT_ID \
#     --member serviceAccount:$PROJECT_NUMBER@cloudbuild.gserviceaccount.com \
#     --role roles/compute.networkAdmin

gcloud projects add-iam-policy-binding $PROJECT_ID \
    --member serviceAccount:$PROJECT_NUMBER@cloudbuild.gserviceaccount.com \
    --role roles/vpcaccess.serviceAgent \
    --condition=None

# gcloud projects add-iam-policy-binding $PROJECT_ID \
#     --member serviceAccount:bq-$PROJECT_NUMBER@bigquery-encryption.iam.gserviceaccount.com \
#     --role roles/cloudkms.cryptoOperator \
#     --condition=None

# gcloud projects add-iam-policy-binding $PROJECT_ID \
#     --member serviceAccount:service-$PROJECT_NUMBER@gs-project-accounts.iam.gserviceaccount.com \
#     --role roles/cloudkms.cryptoKeyEncrypterDecrypter \
#     --condition=None


# gcloud projects add-iam-policy-binding $PROJECT_ID \
#     --member serviceAccount:$PROJECT_NUMBER@cloudbuild.gserviceaccount.com \
#     --role roles/gkehub.serviceAgent

# gcloud projects add-iam-policy-binding $PROJECT_ID \
#     --member serviceAccount:$PROJECT_NUMBER@cloudbuild.gserviceaccount.com \
#     --role roles/dns.admin

gcloud projects add-iam-policy-binding $PROJECT_ID \
    --member serviceAccount:$PROJECT_NUMBER@cloudbuild.gserviceaccount.com \
    --role roles/secretmanager.secretAccessor \
    --condition=None

gcloud projects add-iam-policy-binding $PROJECT_ID \
    --member serviceAccount:$PROJECT_NUMBER@cloudbuild.gserviceaccount.com \
    --role roles/cloudsql.viewer \
    --condition=None

gcloud projects add-iam-policy-binding $PROJECT_ID \
    --member serviceAccount:$PROJECT_NUMBER@cloudbuild.gserviceaccount.com \
    --role roles/cloudkms.cryptoKeyDecrypter \
    --condition=None

gcloud projects add-iam-policy-binding $PROJECT_ID \
    --member serviceAccount:$PROJECT_NUMBER@cloudbuild.gserviceaccount.com \
    --role roles/run.invoker \
    --condition=None

# gcloud iam service-accounts add-iam-policy-binding \
#     $PROJECT_NUMBER-compute@developer.gserviceaccount.com \
#     --member serviceAccount:$PROJECT_NUMBER@cloudbuild.gserviceaccount.com \
#     --role roles/iam.serviceAccountUser

gcloud projects add-iam-policy-binding $PROJECT_ID \
    --member="serviceAccount:service-$PROJECT_NUMBER@gcp-sa-pubsub.iam.gserviceaccount.com" \
    --role='roles/cloudkms.cryptoKeyEncrypterDecrypter'
