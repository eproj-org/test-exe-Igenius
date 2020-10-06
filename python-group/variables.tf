
variable "mig_enabled" {
     default  = false
}
variable "name" {}

variable "env" {}

variable "zone" {
  default = "us-central1-a"
}

variable "region" {
  description = "Region in which to manage GCP resources"
}

variable machine_type {
  description = "Machine type for the VMs in the instance group."
  default     = "f1-micro"
}

variable compute_image {
  description = "Image used for compute VMs."
  default     = "projects/debian-cloud/global/images/family/debian-9"
}

variable target_pools {
  description = "The target load balancing pools to assign this group to."
  type        = list
  default     = []
}

variable service_account_email {
  description = "The email of the service account for the instance template."
  default     = "default"
}

variable service_account_scopes {
  description = "List of scopes for the instance template service account"
  type        = list

  default = [
    "https://www.googleapis.com/auth/compute",
    "https://www.googleapis.com/auth/logging.write",
    "https://www.googleapis.com/auth/monitoring.write",
    "https://www.googleapis.com/auth/devstorage.full_control",
  ]
}

variable update_strategy {
  description = "The strategy to apply when the instance template changes."
  default     = "NONE"
}

variable rolling_update_policy {
  description = "The rolling update policy when update_strategy is ROLLING_UPDATE"
  type        = list
  default     = []
}

/* Autoscaling */
variable autoscaling_max_replicas {
  description = "Autoscaling, max replicas."
  default     = 5
}

variable autoscaling_min_replicas {
  description = "Autoscaling, min replics."
  default     = 1
}

variable autoscaling_cooldown_period {
  description = <<EOF
    The number of seconds that the autoscaler should wait before it starts collecting information from a new instance.
    This prevents the autoscaler from collecting information when the instance is initializing, during which the collected usage would not be reliable. 
  EOF
  
  # With the current setup, it takes 2 minutes for setup since startup
  # Let's give it some room
  default     = 180
}

variable autoscaling_metric {
  description = "Autoscaling, metric policy block as single element array. https://www.terraform.io/docs/providers/google/r/compute_autoscaler.html#metric"
  type        = list
  default     = []
}

variable autoscaling_active_connections_target {
  description = <<EOF
    The target active connection number to maintain in each VM, that triggers the autoscaling.
    OS/NGINX/Network settings can influence this values, but with current setup the limit for each VM is about 64k.
    We should set a target of about 60% that value, to leave enough room/time for scaling.
  EOF

  default = 40000
}

variable autoscaling_cpu_utilization_target {
  description = <<EOF
    The target CPU utilization to maintain in each VM, that triggers the autoscaling.    
    We should set a target of about 80%, just in case the metrics policy is not enough.
  EOF

  default = 0.8
}

/* Network */
variable "network" {
  description = "VPC that resources created in this module must belong"
}

variable "subnetwork" {
  description = "subnet that resources created in this module must belong"
}


