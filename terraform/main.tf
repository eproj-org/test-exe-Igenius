terraform {
  backend "gcs" {}
}
provider "google" {
  project = "igexe-git"
}
provider "google-beta" {
  project = "igexe-git"
}

module "staging-pythonapp-pool" {
  source                   = "./python-group"
  name                     = "igexe-py-app"
  env                      = "test"
  region                   = "us-central1"
  #machine_type             = "f1-micro"
  compute_image            = "projects/debian-cloud/global/images/debian-10-buster-v20200910"
  #compute_image            = "projects/gce-uefi-images/global/images/family/ubuntu-1804-lts"
  update_strategy          = "REPLACE"
  autoscaling_min_replicas = 1
  autoscaling_max_replicas = 2 
  network						= var.network
  subnetwork					= var.subnetwork

  target_pools = [module.staging-external-lb.target_pool] 

}

module "staging-external-lb" {
  source         = "./net-load-balancer"
  name           = "igexe-py-app"
  env            = "test"
  region         = "us-central1"
  network        = var.network
  subnetwork     = var.subnetwork
  instance_group = module.staging-pythonapp-pool.instance_group
  internal_lb_ip = "10.11.0.2"
  service_port   = 8080
  external_lb_ip = "34.91.73.128"
}

