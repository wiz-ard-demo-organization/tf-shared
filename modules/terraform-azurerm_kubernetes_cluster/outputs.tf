output "kubernetes_cluster" {
  description = "The Kubernetes Cluster resource"
  value       = azurerm_kubernetes_cluster.this
  sensitive   = true
} 