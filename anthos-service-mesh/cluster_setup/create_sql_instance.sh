#!/usr/bin/env bash

# Bash safeties: exit on error, no unset variables, pipelines can't hide errors
set -o errexit
set -o nounset
set -o pipefail

cd "$(dirname "$0")"

: "$PROJECT_ID"
: "$PROJECT_NUMBER"
: "$SQL_INSTANCE_NAME"
: "$NETWORK"
: "$KEY_RING"
: "$KEY_CMEK_DB"
: "$REGION"
: "$DB_NUM_CPU"
: "$DB_MEM_SIZE"
: "$DB_STORAGE_SIZE"


export SQL_SA_ID=service-$PROJECT_NUMBER
export SQL_SA=$SQL_SA_ID@gcp-sa-cloud-sql.iam.gserviceaccount.com
echo "Creating service account $SQL_SA"
gcloud beta services identity create \
    --service sqladmin.googleapis.com \
    --project $PROJECT_ID

echo "Granting the service account $SQL_SA access to the key ring $KEY_RING:$KEY_CMEK_DB"
gcloud kms keys add-iam-policy-binding $KEY_CMEK_DB \
    --location $REGION \
    --keyring $KEY_RING \
    --member serviceAccount:$SQL_SA \
    --role roles/cloudkms.cryptoKeyEncrypterDecrypter \
    --project $PROJECT_ID \
    --condition=None

echo "Creating SQL instance $SQL_INSTANCE_NAME"
gcloud beta sql instances create $SQL_INSTANCE_NAME \
    --project $PROJECT_ID \
    --disk-encryption-key projects/$PROJECT_ID/locations/$REGION/keyRings/$KEY_RING/cryptoKeys/$KEY_CMEK_DB \
    --database-version POSTGRES_14 \
    --network $NETWORK \
    --no-assign-ip \
    --cpu $DB_NUM_CPU \
    --memory $DB_MEM_SIZE \
    --storage-size $DB_STORAGE_SIZE \
    --storage-type SSD \
    --storage-auto-increase \
    --availability-type REGIONAL \
    --region $REGION \
    --enable-point-in-time-recovery \
    --backup-start-time 18:00 \
    --maintenance-window-day SAT \
    --maintenance-window-hour 20 \
    --database-flags "log_connections=on,log_disconnections=on,log_checkpoints=on,log_lock_waits=on,log_temp_files=0,cloudsql.enable_pglogical=on,cloudsql.logical_decoding=on" \
    --require-ssl \
    --quiet


# To create a replica
# gcloud sql instances create <replica_name> --project $PROJECT_ID \
#     --master-instance-name=$SQL_INSTANCE_NAME \
#     --network $NETWORK \
#     --no-assign-ip \
#     --storage-type HDD \
#     --availability-type zonal \
#     --zone asia-southeast1-a \
#     --database-flags "log_connections=on,log_disconnections=on,log_checkpoints=on,log_lock_waits=on,log_temp_files=0,cloudsql.enable_pglogical=on,cloudsql.logical_decoding=on"
