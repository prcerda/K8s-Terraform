# Service Account for K10 for GCP
resource "google_service_account" "k10-sa" {
  account_id   = "kasten-${local.saString}-sa"
  display_name = "kasten-${local.saString}-sa"
}

#Creating SA Key for K10
resource "google_service_account_key" "sakey" {
  service_account_id = google_service_account.k10-sa.name
  public_key_type    = "TYPE_X509_PEM_FILE"
}

#Assigning IAM Roles to K10 Service Account
resource "google_project_iam_member" "kasten-default" {
  project = var.project
  role    = "roles/compute.storageAdmin"
  member  = "serviceAccount:${google_service_account.k10-sa.email}"
}

# Service Account for GKE Cluster
resource "google_service_account" "gke-sa" {
  account_id   = "gke-${local.saString}-sa"
  display_name = "gke-${local.saString}-sa"
}

#Assigning IAM Roles to GKE Service Account
# The Google predefined role Kubernetes Engine Node Service Account 
# roles/container.nodeServiceAccount) contains the minimum permissions needed to run a GKE cluster.
resource "google_project_iam_member" "gke-nodes" {
  project = var.project
  role    = "roles/container.nodeServiceAccount"
  member  = "serviceAccount:${google_service_account.gke-sa.email}"
}

#resource "google_project_iam_member" "gke-compute" {
#  project = var.project
#  role    = "roles/compute.admin"
#  member  = "serviceAccount:${google_service_account.gke-sa.email}"
#}

