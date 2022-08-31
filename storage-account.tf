
provider "azurerm" {
  alias           = "aks-infra"
  subscription_id = "${var.aks_infra_subscription_id}"
}

output "storage_account_name" {
  value = "${module.storage_account.storageaccount_name}"
}
