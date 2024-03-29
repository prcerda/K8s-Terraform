output "vnet_name" {
  description = "VNET Name"
  value = azurerm_virtual_network.vnet_network.name
}

output "subnet_name" {
  description = "Subnet Name"
  value = azurerm_subnet.subnet-k10-demo.name
}

output "az_bucket_name" {
  description = "Azure Storage Account name"
  value = azurerm_storage_account.repository.name
}


output "resource_group_name" {
  value = azurerm_resource_group.demo_rgroup.name
}

output "kubernetes_cluster_name" {
  value = azurerm_kubernetes_cluster.aks-cluster.name
}

output "kube_config" {
  value = nonsensitive(azurerm_kubernetes_cluster.aks-cluster.kube_config_raw)
}

output "managed_identity_id" {
  value = azurerm_user_assigned_identity.aks-demo-id.client_id
}
