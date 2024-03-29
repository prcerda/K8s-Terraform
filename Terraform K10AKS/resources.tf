resource "time_static" "epoch" {}
locals {
  saString = "${time_static.epoch.unix}"
}

# Create a resource group if it doesn't exist
resource "azurerm_resource_group" "demo_rgroup" {
    name     = "${var.rgName}-${local.saString}"
    location = var.location
}

# VNET Network
resource "azurerm_virtual_network" "vnet_network" {
    name                = "vnet-k10-${local.saString}"
    address_space       = ["10.50.0.0/16"]
    location            = var.location
    resource_group_name = azurerm_resource_group.demo_rgroup.name
}


#Subnet
resource "azurerm_subnet" "subnet-k10-demo" {
    name                 = "subnet"
    resource_group_name  = azurerm_resource_group.demo_rgroup.name
    virtual_network_name = azurerm_virtual_network.vnet_network.name
    address_prefixes       = ["10.50.1.0/24"]
}

# Create storage account 
resource "azurerm_storage_account" "repository" {
    name                        = "sak10${local.saString}"
    resource_group_name         = azurerm_resource_group.demo_rgroup.name
    location                    = var.location
    account_tier                = "Standard"
    account_replication_type    = "LRS"
}

# Create User Assigned Identity
resource "azurerm_user_assigned_identity" "aks-demo-id" {
    location            = azurerm_resource_group.demo_rgroup.location
    name                = "aks-identity-${local.saString}"
    resource_group_name = azurerm_resource_group.demo_rgroup.name
}

resource "azurerm_kubernetes_cluster" "aks-cluster" {
    name                = "aks-k10-${local.saString}"
    location            = azurerm_resource_group.demo_rgroup.location
    resource_group_name = azurerm_resource_group.demo_rgroup.name
    dns_prefix          = "dns-k10-${local.saString}"

    default_node_pool {
        name            = "default"
        node_count      = 3
        vm_size         = "${var.aks_instance_type}"
        os_disk_size_gb = 30
    }

    identity {
        type = "UserAssigned"
        identity_ids =  [azurerm_user_assigned_identity.aks-demo-id.id]
    }
}
