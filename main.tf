locals {
  tags = var.common_tags
}

resource "azurerm_resource_group" "shared_rg" {
  name     = "${var.product}-shared-${var.env}"
  location = var.location

  tags = local.tags
}

provider "azurerm" {
    features {}
}

