#!/usr/bin/env bash
# One-time setup (Lab 4): a storage account for Terraform state, with locking (blob lease).
# Usage: scripts/bootstrap-state.sh <unique-storage-name> [region]     (3-24 lowercase letters/digits)
set -euo pipefail
SA="${1:?usage: bootstrap-state.sh <unique-storage-name> [region]}"
LOC="${2:-westeurope}"
RG=rg-ai381-tfstate
az group create -n "$RG" -l "$LOC" --tags course=AI381 purpose=tfstate >/dev/null
az storage account create -n "$SA" -g "$RG" -l "$LOC" --sku Standard_LRS --min-tls-version TLS1_2 \
  --allow-blob-public-access false --tags course=AI381 purpose=tfstate >/dev/null
az storage container create --name tfstate --account-name "$SA" --auth-mode login >/dev/null
# The OIDC identity must be able to read and write blobs (state) in this account
APP_ID="${AZURE_CLIENT_ID:-}"
if [ -n "$APP_ID" ]; then
  az role assignment create --assignee "$APP_ID" --role "Storage Blob Data Contributor" \
    --scope "$(az storage account show -n "$SA" -g "$RG" --query id -o tsv)" >/dev/null
fi
echo "State storage ready. Set GitHub variables:  TFSTATE_RG=$RG  TFSTATE_ACCOUNT=$SA"
echo "Locally: cp infra/backend.hcl.example infra/backend.hcl and fill in storage_account_name=$SA"
