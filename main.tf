module "staging-pythonapp-pool" {
  source                   = "./lb-python"
  name                     = "IGexe-pool"
  env                      = "test"
  region                   = "us-central1"
  #machine_type             = "f1-micro"
  compute_image            = "projects/gce-uefi-images/global/images/family/ubuntu-1804-lts"
  update_strategy          = "REPLACE"
  autoscaling_min_replicas = 1
  autoscaling_max_replicas = 2 
  network						= var.network
  subnetwork					= var.subnetwork

}

