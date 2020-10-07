output "target_pool" {
  description = "The `self_link` to the target pool resource created."
  value       = google_compute_target_pool.pythonapp-pool.self_link
}

output "external_ip" {
  description = "The external ip address of the forwarding rule."
  value       = google_compute_forwarding_rule.external.ip_address
}

