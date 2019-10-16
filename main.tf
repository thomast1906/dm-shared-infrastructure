locals {
  tags = "${merge(
    var.common_tags,
    map(
      "Team Contact", var.team_contact,
      "Destroy Me", var.destroy_me
    )
  )}"
}

resource "azurerm_resource_group" "shared_rg" {
  name     = "${var.product}-shared-${var.env}"
  location = "${var.location}"

  tags = "${local.tags}"
}

provider "azurerm" {}
