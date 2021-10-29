
provider "azurerm" {
  version = "=2.82.0"
 }
locals {
  defaultname = "${var.customer}-rg-${var.category}-${var.applicationname}-${var.environment}"
}

resource "azurerm_resource_group" "main" {

  name     = var.name == "" ? local.defaultname : var.name
  location = var.location

  tags = var.tags
}
