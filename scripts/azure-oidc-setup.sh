#!/usr/bin/env bash
# One-time setup (Labs 3 and 4): let GitHub Actions log in to Azure with OIDC, no stored password.
# Run in WSL or Cloud Shell after `az login`.   Usage: scripts/azure-oidc-setup.sh <github-user>/<repo>
set -euo pipefail
REPO="${1:?usage: azure-oidc-setup.sh <github-user>/<repo>}"
APP_NAME="gh-oidc-${REPO//\//-}"
SUB_ID=$(az account show --query id -o tsv)
TENANT_ID=$(az account show --query tenantId -o tsv)

APP_ID=$(az ad app create --display-name "$APP_NAME" --query appId -o tsv)
az ad sp create --id "$APP_ID" >/dev/null 2>&1 || true

# Trust only this repository, and only these GitHub environments
for ENV in production plan; do
  az ad app federated-credential create --id "$APP_ID" --parameters "{
    \"name\": \"${ENV}\",
    \"issuer\": \"https://token.actions.githubusercontent.com\",
    \"subject\": \"repo:${REPO}:environment:${ENV}\",
    \"audiences\": [\"api://AzureADTokenExchange\"]
  }" >/dev/null
done

# Contributor on the subscription (Lab 4 creates resource groups). Narrow this in real projects.
az role assignment create --assignee "$APP_ID" --role Contributor --scope "/subscriptions/$SUB_ID" >/dev/null

echo "Add these as GitHub repository secrets (Settings > Secrets and variables > Actions):"
echo "  AZURE_CLIENT_ID=$APP_ID"
echo "  AZURE_TENANT_ID=$TENANT_ID"
echo "  AZURE_SUBSCRIPTION_ID=$SUB_ID"
echo "With the gh CLI:"
echo "  gh secret set AZURE_CLIENT_ID -b $APP_ID -R $REPO"
echo "  gh secret set AZURE_TENANT_ID -b $TENANT_ID -R $REPO"
echo "  gh secret set AZURE_SUBSCRIPTION_ID -b $SUB_ID -R $REPO"
