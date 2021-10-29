
provider "azurerm" {
  features {}
  version = "=2.82.0"
 }
locals {
  defaultname = "${var.customer}-rg-${var.category}-${var.applicationname}-${var.environment}"
}

resource "azurerm_resource_group" "main" {

  name     = local.defaultname
  location = var.location

  tags = var.tags
}
