
provider "azurerm" {
  features {}
  alias           = "aks-infra"
  subscription_id = "${var.aks_infra_subscription_id}"
}

