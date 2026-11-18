terraform {
  required_version = ">= 1.9"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.81"
    }
  }

  # State lives in Azure Storage (blob lease = state locking), never in Git.
  # Values come from backend.hcl: terraform init -backend-config=backend.hcl
  # In GitHub Actions, ARM_USE_OIDC=true switches both the backend and the provider to OIDC;
  # on your laptop they use your `az login` session.
  backend "azurerm" {
    use_azuread_auth = true
  }
}

provider "azurerm" {
  features {}
}
