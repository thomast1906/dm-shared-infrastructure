module "storage_account" {
  source                    = "git@github.com:hmcts/cnp-module-storage-account?ref=master"
  env                       = "${var.env}"
  storage_account_name      = "${var.product}shared${var.env}"
  resource_group_name       = "${azurerm_resource_group.shared_rg.name}"
  location                  = "${var.location}"
  account_kind              = "StorageV2"
  account_tier              = "Standard"
  account_replication_type  = "LRS"
  access_tier               = "Hot"
  enable_blob_encryption    = true
  enable_file_encryption    = true
  enable_https_traffic_only = true

  // Tags
  common_tags  = "${local.tags}"
  team_contact = "${var.team_contact}"
  destroy_me   = "${var.destroy_me}"
}

// Storage Account Vault Secrets
resource "azurerm_key_vault_secret" "storageaccount_id" {
  name      = "storage-account-id"
  value     = "${module.storage_account.storageaccount_id}"
  vault_uri = "${module.shared_vault.key_vault_uri}"

  network_rules {
    virtual_network_subnet_ids = ["${data.azurerm_virtual_network.aks_core_vnet.id}", "${data.azurerm_subnet.aks-01.id}", "${data.azurerm_subnet.aks-00.id}"]
    bypass                     = ["Logging", "Metrics", "AzureServices"]
    default_action             = "Deny"
  }
}

provider "azurerm" {
  alias           = "aks-infra"
}

data "azurerm_virtual_network" "aks_core_vnet" {
  provider             = "azurerm.aks-infra"
  name                 = "core-${var.env}-vnet"
  resource_group_name  = "aks-infra-${var.env}-rg"
}

data "azurerm_subnet" "aks-00" {
  provider             = "azurerm.aks-infra"
  name                 = "aks-00"
  virtual_network_name = "${data.azurerm_virtual_network.aks_core_vnet.name}"
  resource_group_name  = "${data.azurerm_virtual_network.aks_core_vnet.resource_group_name}"
}

data "azurerm_subnet" "aks-01" {
  provider             = "azurerm.aks-infra"
  name                 = "aks-01"
  virtual_network_name = "${data.azurerm_virtual_network.aks_core_vnet.name}"
  resource_group_name  = "${data.azurerm_virtual_network.aks_core_vnet.resource_group_name}"
}

resource "azurerm_key_vault_secret" "storageaccount_primary_access_key" {
  name      = "storage-account-primary-access-key"
  value     = "${module.storage_account.storageaccount_primary_access_key}"
  vault_uri = "${module.shared_vault.key_vault_uri}"
}

resource "azurerm_key_vault_secret" "storageaccount_secondary_access_key" {
  name      = "storage-account-secondary-access-key"
  value     = "${module.storage_account.storageaccount_secondary_access_key}"
  vault_uri = "${module.shared_vault.key_vault_uri}"
}

resource "azurerm_key_vault_secret" "storageaccount_primary_connection_string" {
  name      = "storage-account-primary-connection-string"
  value     = "${module.storage_account.storageaccount_primary_connection_string}"
  vault_uri = "${module.shared_vault.key_vault_uri}"
}

resource "azurerm_key_vault_secret" "storageaccount_secondary_connection_string" {
  name      = "storage-account-secondary-connection-string"
  value     = "${module.storage_account.storageaccount_secondary_connection_string}"
  vault_uri = "${module.shared_vault.key_vault_uri}"
}


output "storage_account_name" {
  value = "${module.storage_account.storageaccount_name}"
}
