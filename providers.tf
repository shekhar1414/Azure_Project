terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.112.0"
    }
  }
}

provider "azurerm" {
  features {}
  client_id       = var.client_id
  client_secret   = var.client_secret
  tenant_id       = var.tenant_id
  subscription_id = var.subscription_id
}

// terraform {
//   backend "azurerm" {
//     resource_group_name  = "${local.rg_name}"
//     storage_account_name = lower(replace("${var.prefix}sa01", "-", ""))
//     container_name       = "tfstate"
//     key                  = "terraform.tfstate"
//   }
// }
terraform {
  backend "azurerm" {
    resource_group_name  = "ACC-23377-Azure-NPRD-AICAP-RG01"
    storage_account_name = "acc23377sa01"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
}
