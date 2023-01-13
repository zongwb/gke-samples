#!/usr/bin/env bash

# Bash safeties: exit on error, no unset variables, pipelines can't hide errors
set -o errexit
set -o nounset
set -o pipefail

: "$PROJECT_ID"

echo "Removing the default network"
gcloud compute firewall-rules delete default-allow-icmp default-allow-internal default-allow-rdp default-allow-ssh --project $PROJECT_ID || echo "Something went wrong when removing firewall rules, but proceed"
gcloud compute networks delete default --project $PROJECT_ID || echo "Something went wrong when deleteing the default network, but proceed"
