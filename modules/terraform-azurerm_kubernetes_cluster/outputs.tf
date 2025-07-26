output "cluster_id" {
  description = "The ID of the Kubernetes Cluster"
  value       = azurerm_kubernetes_cluster.this.id
}

output "cluster_name" {
  description = "The name of the Kubernetes Cluster"
  value       = azurerm_kubernetes_cluster.this.name
}

output "cluster_fqdn" {
  description = "The FQDN of the Azure Kubernetes Managed Cluster"
  value       = azurerm_kubernetes_cluster.this.fqdn
}

output "cluster_private_fqdn" {
  description = "The FQDN for the Kubernetes Cluster when private link has been enabled"
  value       = azurerm_kubernetes_cluster.this.private_fqdn
}

output "cluster_portal_fqdn" {
  description = "The FQDN for the Azure Portal resources when private link has been enabled"
  value       = azurerm_kubernetes_cluster.this.portal_fqdn
}

output "kube_config" {
  description = "A kube_config block containing the configuration to connect to the cluster"
  value       = azurerm_kubernetes_cluster.this.kube_config
  sensitive   = true
}

output "kube_config_raw" {
  description = "Raw Kubernetes config to be used by kubectl command"
  value       = azurerm_kubernetes_cluster.this.kube_config_raw
  sensitive   = true
}

output "kube_admin_config" {
  description = "A kube_admin_config block containing the admin configuration to connect to the cluster"
  value       = azurerm_kubernetes_cluster.this.kube_admin_config
  sensitive   = true
}

output "kube_admin_config_raw" {
  description = "Raw Kubernetes admin config to be used by kubectl command"
  value       = azurerm_kubernetes_cluster.this.kube_admin_config_raw
  sensitive   = true
}

output "node_resource_group" {
  description = "The auto-generated Resource Group which contains the resources for this Managed Kubernetes Cluster"
  value       = azurerm_kubernetes_cluster.this.node_resource_group
}

output "network_profile" {
  description = "A network_profile block with the network configuration of the cluster"
  value       = azurerm_kubernetes_cluster.this.network_profile
}

output "identity" {
  description = "An identity block with the identity configuration of the cluster"
  value       = azurerm_kubernetes_cluster.this.identity
}

output "kubelet_identity" {
  description = "A kubelet_identity block containing the user-assigned identity used by the kubelet"
  value       = azurerm_kubernetes_cluster.this.kubelet_identity
}

output "cluster_ca_certificate" {
  description = "The cluster CA certificate"
  value       = length(azurerm_kubernetes_cluster.this.kube_config) > 0 ? azurerm_kubernetes_cluster.this.kube_config[0].cluster_ca_certificate : ""
  sensitive   = true
}

output "client_certificate" {
  description = "The client certificate"
  value       = length(azurerm_kubernetes_cluster.this.kube_config) > 0 ? azurerm_kubernetes_cluster.this.kube_config[0].client_certificate : ""
  sensitive   = true
}

output "client_key" {
  description = "The client key"
  value       = length(azurerm_kubernetes_cluster.this.kube_config) > 0 ? azurerm_kubernetes_cluster.this.kube_config[0].client_key : ""
  sensitive   = true
}

output "host" {
  description = "The Kubernetes cluster server host"
  value       = length(azurerm_kubernetes_cluster.this.kube_config) > 0 ? azurerm_kubernetes_cluster.this.kube_config[0].host : ""
}

output "username" {
  description = "The username for basic authentication to the Kubernetes cluster"
  value       = length(azurerm_kubernetes_cluster.this.kube_config) > 0 ? azurerm_kubernetes_cluster.this.kube_config[0].username : ""
}

output "password" {
  description = "The password for basic authentication to the Kubernetes cluster"
  value       = length(azurerm_kubernetes_cluster.this.kube_config) > 0 ? azurerm_kubernetes_cluster.this.kube_config[0].password : ""
  sensitive   = true
}

output "oidc_issuer_url" {
  description = "The OIDC issuer URL that is associated with the cluster"
  value       = azurerm_kubernetes_cluster.this.oidc_issuer_url
}

output "http_application_routing_zone_name" {
  description = "The Zone Name of the HTTP Application Routing"
  value       = azurerm_kubernetes_cluster.this.http_application_routing_zone_name
}

output "oms_agent" {
  description = "An oms_agent block with the Log Analytics integration configuration"
  value       = azurerm_kubernetes_cluster.this.oms_agent
}

output "ingress_application_gateway" {
  description = "An ingress_application_gateway block with the Application Gateway integration configuration"
  value       = azurerm_kubernetes_cluster.this.ingress_application_gateway
}

output "key_vault_secrets_provider" {
  description = "A key_vault_secrets_provider block with the Key Vault Secrets Provider configuration"
  value       = azurerm_kubernetes_cluster.this.key_vault_secrets_provider
} 