
provider "azurerm" {
  version = "=2.82.0"
}

locals {
  defaultname = "testrg"
}

resource "azurerm_resource_group" "main" {

  name     = local.defaultname
  location = "West US"
}
