module "storage_account" {
  source                    = "git@github.com:hmcts/cnp-module-storage-account?ref=master"
  env                       = var.env
  storage_account_name      = "${var.product}shared${var.env}"
  resource_group_name       = azurerm_resource_group.shared_rg.name
  location                  = var.location
  account_kind              = "StorageV2"
  account_tier              = "Standard"
  account_replication_type  = "LRS"
  access_tier               = "Hot"
  enable_blob_encryption    = true
  enable_file_encryption    = true
  enable_https_traffic_only = true
  // Tags
  common_tags               = local.tags
  team_contact              = var.team_contact
  destroy_me                = var.destroy_me

  sa_subnets = ["${data.azurerm_subnet.ase.id}", "${data.azurerm_subnet.aks-01.id}", "${data.azurerm_subnet.aks-00.id}"]
}


// Storage Account Vault Secrets
resource "azurerm_key_vault_secret" "storageaccount_id" {
  name         = "storage-account-id"
  value        = module.storage_account.storageaccount_id
  key_vault_id = module.shared_vault.key_vault_id
}


provider "azurerm" {
  alias           = "aks-infra"
  subscription_id = var.aks_infra_subscription_id
}

data "azurerm_virtual_network" "aks_core_vnet" {
  provider             = "azurerm.aks-infra"
  name                 = "core-${var.env}-vnet"
  resource_group_name  = "aks-infra-${var.env}-rg"
}

data "azurerm_subnet" "aks-00" {
  provider             = "azurerm.aks-infra"
  name                 = "aks-00"
  virtual_network_name = data.azurerm_virtual_network.aks_core_vnet.name
  resource_group_name  = data.azurerm_virtual_network.aks_core_vnet.resource_group_name
}

data "azurerm_subnet" "aks-01" {
  provider             = "azurerm.aks-infra"
  name                 = "aks-01"
  virtual_network_name = data.azurerm_virtual_network.aks_core_vnet.name
  resource_group_name  = data.azurerm_virtual_network.aks_core_vnet.resource_group_name
}

data "azurerm_virtual_network" "ase_core_vnet" {
  name                 = "core-infra-vnet-${var.env}"
  resource_group_name  = "core-infra-${var.env}"
}

data "azurerm_subnet" "ase" {
  name                 = "core-infra-subnet-3-${var.env}"
  virtual_network_name = data.azurerm_virtual_network.ase_core_vnet.name
  resource_group_name  = data.azurerm_virtual_network.ase_core_vnet.resource_group_name
}

output "storage_account_name" {
  value = module.storage_account.storageaccount_name
}
