terraform {
  backend "gcs" {}
}
provider "google" {
}

variable "routing_mode" {
default = "REGIONAL"
}
variable "region1" {
default = "us-central1"
}
 
variable "region2" {
default = "us-central1"
}

resource "google_compute_network" "networks" {
  for_each = local.projects

  name                    = format("%s%s", each.value.network_name, format("ig-exe-%s", each.key))
  project                 = each.value.project_id
  auto_create_subnetworks = false
  routing_mode            = var.routing_mode
}


resource "google_compute_subnetwork" "normal-subnet-1" {
  for_each = local.projects

  name                     = format("snet-%s%s","exe-ig-1", each.key)
  ip_cidr_range            = each.value.networks.no1_nodes
  region                   = var.region1
  network                  = google_compute_network.networks[each.key].name
  #private_ip_google_access = true
  project                  = each.value.project_id
}

resource "google_compute_subnetwork" "normal-subnet-2" {
  for_each = local.projects

  name                     = format("snet-%s%s", "exe-ig-2", each.key)
  ip_cidr_range            = each.value.networks.no2_nodes
  region                   = var.region2
  network                  = google_compute_network.networks[each.key].name
  #private_ip_google_access = true
  project                  = each.value.project_id
}
