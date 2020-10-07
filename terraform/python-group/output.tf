output "targets" {
  value = google_compute_region_instance_group_manager.pythonapp-group-manager[0].self_link
}


output "instance_group" {
  value = google_compute_region_instance_group_manager.pythonapp-group-manager[0].instance_group
  #value = google_compute_instance_group.unmanaged-python-pool[0].self_link
}
