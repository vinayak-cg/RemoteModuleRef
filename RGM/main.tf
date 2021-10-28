
provider "azurerm" {
  version = "=1.32.0"
}

locals {
  defaultname = "testrg"
}

resource "azurerm_resource_group" "main" {

  name     = local.defaultname
  location = "West US"
}
