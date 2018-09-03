resource "azurerm_resource_group" "shared_rg" {
  name     = "${var.product}-shared-${var.env}"
  location = "${var.location}"
}
