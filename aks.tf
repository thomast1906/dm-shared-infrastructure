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