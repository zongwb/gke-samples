#!/usr/bin/env bash

# Bash safeties: exit on error, no unset variables, pipelines can't hide errors
set -o errexit
set -o nounset
set -o pipefail

cd "$(dirname "$0")"

: "$PROJECT_ID"
: "$POLICY_NAME"


echo "Creating security-policies $POLICY_NAME"

gcloud compute security-policies create $POLICY_NAME \
    --description "Common security fules"

gcloud compute security-policies rules create 1000 \
    --security-policy $POLICY_NAME \
    --expression "evaluatePreconfiguredWaf('xss-v33-stable', {'sensitivity': 1})" \
    --action "deny-403" \
    --description "XSS attack filtering"

gcloud compute security-policies rules create 1001 \
    --security-policy $POLICY_NAME \
    --expression "evaluatePreconfiguredWaf('sqli-v33-stable', {'sensitivity': 1})" \
    --action "deny-403" \
    --description "SQL injection filtering"

gcloud compute security-policies rules create 1002 \
    --security-policy $POLICY_NAME \
    --expression "evaluatePreconfiguredWaf('scannerdetection-v33-stable', {'sensitivity': 1})" \
    --action "deny-403" \
    --description "Scanner filtering"

gcloud compute security-policies rules create 1003 \
    --security-policy $POLICY_NAME \
    --expression "evaluatePreconfiguredWaf('rce-v33-stable', {'sensitivity': 1})" \
    --action "deny-403" \
    --description "Remote code execution attack filtering"

gcloud compute security-policies rules create 1004 \
    --security-policy $POLICY_NAME \
    --expression "evaluatePreconfiguredWaf('lfi-v33-stable', {'sensitivity': 1})" \
    --action "deny-403" \
    --description "Local file inclusion attack filtering"

gcloud compute security-policies rules create 1005 \
    --security-policy $POLICY_NAME \
    --expression "evaluatePreconfiguredWaf('rfi-v33-stable', {'sensitivity': 1})" \
    --action "deny-403" \
    --description "Local file inclusion attack filtering"

gcloud compute security-policies rules create 1006 \
    --security-policy $POLICY_NAME \
    --expression "evaluatePreconfiguredWaf('protocolattack-v33-stable', {'sensitivity': 1})" \
    --action "deny-403" \
    --description "Protocol attack filtering"

gcloud compute security-policies rules create 1007 \
    --security-policy $POLICY_NAME \
    --expression "evaluatePreconfiguredWaf('sessionfixation-v33-stable', {'sensitivity': 1})" \
    --action "deny-403" \
    --description "Session fixation attack filtering"

gcloud compute security-policies rules create 1008 \
    --security-policy $POLICY_NAME \
    --expression "evaluatePreconfiguredWaf('cve-canary', {'sensitivity': 1})" \
    --action "deny-403" \
    --description "CVEs attack filtering"

