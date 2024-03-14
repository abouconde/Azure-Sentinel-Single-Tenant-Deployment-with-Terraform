provider "azurerm" {
  features {}
}

variable "resource_prefix" {
  type    = string
  default = "mug"
}

variable "location" {
  description = "Azure location for all resources."
  default     = "France Central"
}

resource "azurerm_resource_group" "sentinel_rg" {
  name     = "${var.resource_prefix}-sentinel-rg"
  location = var.location
}

resource "azurerm_log_analytics_workspace" "sentinel_workspace" {
  name                = "${var.resource_prefix}-sentinel-workspace"
  location            = azurerm_resource_group.sentinel_rg.location
  resource_group_name = azurerm_resource_group.sentinel_rg.name
  sku                 = "PerGB2018"
}

resource "azurerm_log_analytics_solution" "sentinel_solution" {
  solution_name         = "SecurityInsights"
  location              = azurerm_log_analytics_workspace.sentinel_workspace.location
  resource_group_name   = azurerm_resource_group.sentinel_rg.name
  workspace_resource_id = azurerm_log_analytics_workspace.sentinel_workspace.id
  workspace_name        = azurerm_log_analytics_workspace.sentinel_workspace.name

  plan {
    publisher = "Microsoft"
    product   = "OMSGallery/SecurityInsights"  # Corrected product name
  }
}

resource "azurerm_storage_account" "sentinel_storage" {
  name                     = "${var.resource_prefix}stgacc"
  resource_group_name      = azurerm_resource_group.sentinel_rg.name
  location                 = azurerm_resource_group.sentinel_rg.location
  account_tier             = "Standard"
  account_replication_type = "GRS"
}

resource "azurerm_eventhub_namespace" "sentinel_eventhub_ns" {
  name                = "${var.resource_prefix}-eventhub-ns"
  location            = azurerm_resource_group.sentinel_rg.location
  resource_group_name = azurerm_resource_group.sentinel_rg.name
  sku                 = "Standard"
}

resource "azurerm_eventhub" "sentinel_eventhub" {
  name                = "${var.resource_prefix}-eventhub"
  namespace_name      = azurerm_eventhub_namespace.sentinel_eventhub_ns.name
  resource_group_name = azurerm_resource_group.sentinel_rg.name
  partition_count     = 2
  message_retention   = 1
}

resource "azurerm_kusto_cluster" "sentinel_adx" {
  name                = "${var.resource_prefix}-adx-cluster"
  location            = azurerm_resource_group.sentinel_rg.location
  resource_group_name = azurerm_resource_group.sentinel_rg.name

  sku {
    name     = "Standard_D11_v2"
    capacity = 2
  }
}
