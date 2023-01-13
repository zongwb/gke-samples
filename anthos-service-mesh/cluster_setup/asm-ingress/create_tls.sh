#!/usr/bin/env bash

# Bash safeties: exit on error, no unset variables, pipelines can't hide errors
set -o errexit
set -o nounset
set -o pipefail

cd "$(dirname "$0")"

: "$PROJECT_ID"
: "$BASE_DOMAIN"
: "$EDGE2MESH_TLS_SECRET"


echo "Creating self-signed TLS certificates between the external load balancer and the mesh ingress"

openssl req -new -newkey rsa:4096 -days 10000 -nodes -x509 \
    -subj "/CN=${BASE_DOMAIN}/O=Edge2Mesh Inc" \
    -keyout ${BASE_DOMAIN}.key \
    -out ${BASE_DOMAIN}.crt

kubectl -n asm-ingress create secret tls $EDGE2MESH_TLS_SECRET \
    --key=${BASE_DOMAIN}.key \
    --cert=${BASE_DOMAIN}.crt
