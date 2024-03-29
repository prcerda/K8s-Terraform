output "vpc_name" {
  description = "VPC Name"
  value = google_compute_network.vpc_network.name
}

output "subnet_name" {
  description = "Subnet Name"
  value = google_compute_subnetwork.subnet.name
}

output "k10_bucket_name" {
  description = "Kasten Bucket name"
  value = google_storage_bucket.repository.id
}

output "sa_key" {
  description = "GCP Service Account Key"
  value = nonsensitive(google_service_account_key.sakey.private_key)
}

output "kubernetes_cluster_name" {
  value       = google_container_cluster.primary.name
  description = "GKE Cluster Name"
}

output "kubernetes_cluster_endpoint" {
  value       = google_container_cluster.primary.endpoint
  description = "GKE Cluster Host"
}

output "gke_token" {
  description = "GKE Token"
  value = nonsensitive(data.google_client_config.provider.access_token)
}

output "gke_cacert" {
  description = "GKE CA Cert"
  value = data.google_container_cluster.gke_cluster.master_auth[0].cluster_ca_certificate
}
