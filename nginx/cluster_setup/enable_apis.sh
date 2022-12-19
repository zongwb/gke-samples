#!/usr/bin/env bash

# Bash safeties: exit on error, no unset variables, pipelines can't hide errors
set -o errexit
set -o nounset
set -o pipefail

cd "$(dirname "$0")"

gcloud services list --enabled --project $PROJECT_ID --quiet
sed -n '1,20'p apis-enabled.txt | xargs gcloud services enable --quiet
sed -n '21,40'p apis-enabled.txt | xargs gcloud services enable --quiet
sed -n '41,60'p apis-enabled.txt | xargs gcloud services enable --quiet
