variable "region" {
  type        = string
  description = "Region for cloud resources."
  default     = "us-central1"
}

variable "network" {
  type        = string
  description = "Name of the network to create resources in."
  default     = "default"
}

variable "internal_lb_ip" {
  type        = string
  description = "IP address for internal load balancer (must belong to subnetwork CIDR)"
}

variable "external_lb_ip" {
  type        = string
  description = "IP address for external load balancer"
}

variable "subnetwork" {
  type        = string
  description = "Name of the subnetwork in which to create internal load balancer."
}

variable "instance_group" {
  type        = string
  description = "Instance group to use as backend of internal load balancer."
}

variable "firewall_project" {
  type        = string
  description = "Name of the project to create the firewall rule in. Useful for shared VPC. Default is var.project."
  default     = ""
}

variable "name" {
  type        = string
  description = "Name for the forwarding rule and prefix for supporting resources."
}

variable "env" {}


variable "service_port" {
  description = "TCP port used to check service health."
  default     = 8080
}

variable "health_port" {
  description = "TCP port used to check service health."
  default     = 8080
}

variable "session_affinity" {
  type        = string
  description = "How to distribute load. Options are `NONE`, `CLIENT_IP` and `CLIENT_IP_PROTO`"
  default     = "NONE"
}
