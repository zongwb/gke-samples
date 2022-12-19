#!/usr/bin/env bash

# Bash safeties: exit on error, no unset variables, pipelines can't hide errors
set -o errexit
set -o nounset
set -o pipefail

cd "$(dirname "$0")"

: "$PROJECT_ID"
: "$PROJECT_NUMBER"
: "$APP_SA_NAME"
APP_SA_NAME_FULL=${APP_SA_NAME}@${PROJECT_ID}.iam.gserviceaccount.com

echo "Creating service account $APP_SA_NAME_FULL"
gcloud iam service-accounts create $APP_SA_NAME \
    --project $PROJECT_ID \
    --description "App default service account" \
    --display-name "App default service account"


roles="roles/bigquery.dataEditor roles/bigquery.dataOwner roles/bigquery.dataViewer roles/bigquery.user roles/cloudfunctions.invoker roles/cloudsql.editor roles/compute.networkUser roles/compute.networkViewer roles/pubsub.publisher roles/pubsub.subscriber roles/run.invoker"
echo "Adding IAM roles to $APP_SA_NAME_FULL"
for ROLE in $roles
do
    gcloud projects add-iam-policy-binding $PROJECT_ID \
    --member "serviceAccount:$APP_SA_NAME_FULL" \
    --condition=None \
    --role $ROLE
done
