terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.112.0"
    }
    random = {
      source = "hashicorp/random"
      version = "~> 3.5.1"
    }
  }
}

provider "azurerm" {
  features {}
}

// terraform {
//   backend "azurerm" {
//     resource_group_name  = "${local.rg_name}"
//     storage_account_name = lower(replace("${var.prefix}sa01", "-", ""))
//     container_name       = "tfstate"
//     key                  = "terraform.tfstate"
//   }
// }
// terraform {
//   backend "azurerm" {
//     resource_group_name  = "ACC-23377-Azure-NPRD-AICAP-RG01"
//     storage_account_name = "acc23377sa01"
//     container_name       = "tfstate"
//     key                  = "terraform.tfstate"
//   }
// }
