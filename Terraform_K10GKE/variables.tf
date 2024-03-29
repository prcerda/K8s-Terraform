variable "region" {
  type = string
}

variable "project" {
  type = string
}

variable "az" {
  type = string
}

variable "owner" {
  type = string
}

variable "activity" {
  type = string
}

variable "vpc_cidr_block_ipv4" {
    type = string
}

variable "subnet_cidr_block_ipv4" {
    type = string
}

variable "gke_username" {
  default     = ""
  description = "gke username"
}

variable "gke_password" {
  default     = ""
  description = "gke password"
}

variable "gke_num_nodes" {
  default     = 2
  description = "number of gke nodes"
}