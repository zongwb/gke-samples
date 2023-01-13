#!/usr/bin/env bash

# Bash safeties: exit on error, no unset variables, pipelines can't hide errors
set -o errexit
set -o nounset
set -o pipefail

cd "$(dirname "$0")"

: "$BASE_DOMAIN"
: "$GCLB_IP"

echo "Setting up http-2-https redirect"

envsubst < ./web-map-http.yaml | gcloud compute url-maps validate --source -
envsubst < ./web-map-http.yaml | gcloud compute url-maps import web-map-http --global --source -

gcloud compute target-http-proxies create http-lb-proxy \
    --url-map=web-map-http \
    --global

gcloud compute forwarding-rules create http-content-rule \
    --load-balancing-scheme=EXTERNAL \
    --network-tier=PREMIUM \
    --address=$GCLB_IP \
    --global \
    --target-http-proxy=http-lb-proxy \
    --ports=80
