#!/usr/bin/env bash

# Bash safeties: exit on error, no unset variables, pipelines can't hide errors
set -o errexit
set -o nounset
set -o pipefail

cd "$(dirname "$0")"

export BACKEND_SRV=$(gcloud compute backend-services list --format="get(name)" | grep k8s)
echo "Adding custom HTTP response headers to backend-service $BACKEND_SRV"
gcloud compute backend-services update $BACKEND_SRV \
    --global \
    --custom-response-header='X-Content-Type-Options: nosniff' \
    --custom-response-header='X-Frame-Options: SAMEORIGIN' \
    --custom-response-header='Referrer-Policy: same-origin' \
    --custom-response-header='Strict-Transport-Security: 31536000; includeSubDomains' \
    --custom-response-header='Expect-CT: max-age=86400, enforce' \
    --custom-response-header='X-XSS-Protection: 1; mode=block'
