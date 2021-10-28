terraform {
  required_version = "0.12.6"
}

provider "azurerm" {
  version = "1.32.0"
}

locals {
  defaultname = "${var.customer}-rg-${var.category}-${var.applicationname}-${var.environment}"
}

resource "azurerm_resource_group" "main" {

  name     = var.name == "" ? local.defaultname : var.name
  location = var.location

  tags = var.tags
}
