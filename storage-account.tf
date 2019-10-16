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

locals {
  account_name      = "${replace("${var.product}${var.env}", "-", "")}"
  mgmt_network_name = "${var.subscription == "prod" || var.subscription == "nonprod" ? "mgmt-infra-prod" : "mgmt-infra-sandbox"}"
  trusted_vnet_name = ""
}

// Storage Account Vault Secrets
resource "azurerm_key_vault_secret" "storageaccount_id" {
  name      = "storage-account-id"
  value     = "${module.storage_account.storageaccount_id}"
  vault_uri = "${module.shared_vault.key_vault_uri}"

  network_rules {
    virtual_network_subnet_ids = ["${data.azurerm_subnet.ase_subnet.id}", "${data.azurerm_subnet.aks_subnet.id}"]
    bypass                     = ["Logging", "Metrics", "AzureServices"]
    default_action             = "Deny"
  }
}

data "azurerm_subnet" "ase_subnet" {
  name                 = "ase-subnet"
  virtual_network_name = "${local.trusted_vnet_name}"
  resource_group_name  = "${local.trusted_vnet_name}"
}

data "azurerm_subnet" "aks_subnet" {
  name                 = "aks-subnet"
  virtual_network_name = "${local.mgmt_network_name}"
  resource_group_name  = "${local.mgmt_network_name}"
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
