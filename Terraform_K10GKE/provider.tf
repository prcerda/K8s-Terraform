# Define Terraform provider
terraform {
  required_version = "~> 1.0"
  required_providers {
    ansible = {
      version = "~> 1.0.0"
      source  = "ansible/ansible"
    }
    google = {
      source = "hashicorp/google"
      version = "4.50.0" # pinning version
    }    
  }
}

# Define GCP provider
provider "google" {
  project     = var.project
  region      = var.region
  zone        = var.az
}

resource "time_static" "epoch" {}
locals {
  saString = "${time_static.epoch.unix}"
}
