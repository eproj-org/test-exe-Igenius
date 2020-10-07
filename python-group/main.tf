data "template_file" "startup_script_config" {
  template = file("${path.module}/scripts/startup.sh.tpl")
}

resource "google_compute_instance_template" "pythonapp-template" {
   count = var.ist_g_enabled ? 1 : 0

  name_prefix  = "pythonapp-template-${var.env}-"
  machine_type = var.machine_type
  region       = var.region
  
  tags = [
    "pythonapp-pool"
  ]

  labels = {
    "pythonapp-pool" = ""

    # This one can be used for Prometheus discovery via gce_sd filter.
    "role"        = "pythonapp-pool"
  }

  # boot disk
  disk {
    source_image = var.compute_image
    auto_delete  = true
    boot         = true
  }

  metadata_startup_script = data.template_file.startup_script_config.rendered

  network_interface {
    network = var.network

    subnetwork = var.subnetwork
  }

  service_account {
    # email  = var.service_account_email     # not using an email service account defaults to developer service account
    scopes = var.service_account_scopes
  }

  scheduling {
    automatic_restart   = true
    on_host_maintenance = "MIGRATE"
  }

  # Instance Templates cannot be updated after creation with the Google Cloud Platform API.
  # Terraform will destroy the existing resource and create a replacement
  lifecycle {
    create_before_destroy = true
  }

  # Shielded VM provides verifiable integrity to prevent against malware and rootkits
#  shielded_instance_config {
#    enable_secure_boot          = true
#    enable_vtpm                 = true
#    enable_integrity_monitoring = true
#  }
}

data "google_compute_image" "my_image" {
  family  = "debian-10"
  project = "debian-cloud"
}

resource "google_compute_instance" "pythonapp" {
   count = var.ist_g_enabled ? 1 : 0

  name  = "pythonapp-${var.env}"
  machine_type = var.machine_type
  zone =var.zone
  allow_stopping_for_update = true 

  tags = [
    "pythonapp-pool"
  ]

  labels = {
    "pythonapp-pool" = ""

    # This one can be used for Prometheus discovery via gce_sd filter.
    "role"        = "pythonapp-pool"
  }

  # boot disk
  boot_disk {
    initialize_params {
      image = data.google_compute_image.my_image.self_link
    }
    #source = var.compute_image
    auto_delete  = true
  }

  metadata_startup_script = data.template_file.startup_script_config.rendered

  network_interface {
    #network = var.network

    subnetwork = var.subnetwork
  }

  service_account {
    # email  = var.service_account_email     # not using an email service account defaults to developer service account
    scopes = var.service_account_scopes
  }

  scheduling {
    automatic_restart   = true
    on_host_maintenance = "MIGRATE"
  }


  # Shielded VM provides verifiable integrity to prevent against malware and rootkits
#  shielded_instance_config {
#    enable_secure_boot          = true
#    enable_vtpm                 = true
#    enable_integrity_monitoring = true
#  }
}


resource "google_compute_instance_group" "unmanaged-python-pool" {
  count = var.ist_g_enabled ? 1 : 0

  name        = "terraform-webservers"
  description = "Terraform test instance group"

  instances = [
    google_compute_instance.pythonapp[0].self_link
  ]

  named_port {
    name = "http"
    port = "8080"
  }

 # Instance Templates cannot be updated after creation with the Google Cloud Platform API.
  # Terraform will destroy the existing resource and create a replacement
  lifecycle {
    create_before_destroy = true
  }

  zone = "us-central1-a"
}

resource "google_compute_region_instance_group_manager" "pythonapp-group-manager" {
  count = var.ist_g_enabled ? 1 : 0

  provider           = google-beta
  name               = "${var.name}-${var.env}"
  base_instance_name = "pythonapp-${var.env}"
  region             = var.region
  target_pools       = var.target_pools

  version {
    name              = "pythonapp"
    instance_template = google_compute_instance_template.pythonapp-template[0].self_link
  }


  update_policy {
    type                         = "PROACTIVE"
    instance_redistribution_type = "PROACTIVE"
    minimal_action               = "REPLACE"
    max_surge_fixed              = 3
    max_unavailable_fixed        = 0
    min_ready_sec                = 60
  }

  auto_healing_policies {
    health_check      = google_compute_health_check.pythonapp_autohealing_health_check[0].self_link
    initial_delay_sec = 300
  }
}

resource "google_compute_region_autoscaler" "pythonapp_autoscaler" {
  count = var.ist_g_enabled ? 1 : 0

  provider = google-beta
  name     = "${var.name}-autoscaler-${var.env}"
  region   = var.region

  target = google_compute_region_instance_group_manager.pythonapp-group-manager[0].self_link

  autoscaling_policy {
    max_replicas    = var.autoscaling_max_replicas
    min_replicas    = var.autoscaling_min_replicas

    cpu_utilization {
      target = var.autoscaling_cpu_utilization_target
    }
  }
}

resource "google_compute_health_check" "pythonapp_autohealing_health_check" {
  count = var.ist_g_enabled ? 1 : 0

  name                = "${var.name}-autohealing-health-check-${var.env}"

  check_interval_sec  = 5
  timeout_sec         = 5
  healthy_threshold   = 2
  unhealthy_threshold = 10 # 50 seconds

  http_health_check {
    request_path = "/"
    port         = "8080"
  }
}

resource "google_compute_firewall" "pythonapp-lb-network-allow-sh" {
  name    = "pythonapp-lb-allow-hh-${var.env}"
  network = var.network

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  target_tags = ["pythonapp-pool", var.name]
}

resource "google_compute_firewall" "pythonapp-lb-network-allow-http" {
  name    = "pythonapp-lb-allow-http-${var.env}"
  network = var.network

  allow {
    protocol = "tcp"
    ports    = ["80","8080"]
  }
  source_ranges = ["130.211.0.0/22", "35.191.0.0/16", "130.211.0.0/22", "35.191.0.0/16"]
  target_tags = ["pythonapp-pool", var.name]
}

