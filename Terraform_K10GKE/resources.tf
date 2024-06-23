# VPC Network
resource "google_compute_network" "vpc_network" {
  provider = google
  name = "vpc-kasten-${local.saString}"
  auto_create_subnetworks = false
}

# Create an IP address
resource "google_compute_global_address" "private_ip_alloc" {
  name          = "private-ip-alloc"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = google_compute_network.vpc_network.id
}

# Create a private connection
resource "google_service_networking_connection" "default" {
  network                 = google_compute_network.vpc_network.id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_ip_alloc.name]
}

#Subnet
resource "google_compute_subnetwork" "subnet" {
  name          = "kasten-demo"
  ip_cidr_range = "10.2.0.0/16"
  region        = var.region
  network       = google_compute_network.vpc_network.id
  private_ip_google_access = true
}

#Storage Account in GCS
resource "google_storage_bucket" "repository" {
  name          = "gcs-kasten-${local.saString}"
  location      = var.region
  storage_class = "STANDARD"
  force_destroy = true
  uniform_bucket_level_access = true
  public_access_prevention = "enforced"
}

# GKE cluster
  # We can't create a cluster with no node pool defined, but we want to only use
  # separately managed node pools. So we create the smallest possible default
  # node pool and immediately delete it.

resource "google_container_cluster" "primary" {
  name     = "gke-k10-${local.saString}"
  location = var.region
  remove_default_node_pool = true
  initial_node_count       = 1
  network    = google_compute_network.vpc_network.name
  subnetwork = google_compute_subnetwork.subnet.name
}

# Separately Managed Node Pool
resource "google_container_node_pool" "primary_nodes" {
  name       = google_container_cluster.primary.name
  location   = var.region
  cluster    = google_container_cluster.primary.name
  node_count = var.gke_num_nodes

  node_config {
    preemptible  = false
    machine_type = "e2-standard-2"
    service_account = google_service_account.gke-sa.email
    labels = {
      owner = var.owner
      activity = var.activity
    }
    tags         = ["gke-node", "${var.project}-gke"]
    metadata = {
      disable-legacy-endpoints = "true"
    }
  }
}

data "google_client_config" "provider" {}

data "google_container_cluster" "gke_cluster" {
  name     = google_container_cluster.primary.name
  location = var.region
}
