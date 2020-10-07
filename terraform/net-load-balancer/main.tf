resource "google_compute_forwarding_rule" "external" {
  name                  = "${var.name}-${var.env}-external"
  region                = var.region
  target                = google_compute_target_pool.pythonapp-pool.self_link
  load_balancing_scheme = "EXTERNAL"
  port_range            = var.service_port
  ip_protocol           = "TCP"
  #ip_address            = var.external_lb_ip
}

resource "google_compute_forwarding_rule" "internal" {
  name                  = "${var.name}-${var.env}-internal"
  region                = var.region
  backend_service       = google_compute_region_backend_service.internal.self_link
  load_balancing_scheme = "INTERNAL"
 # ip_address            = var.internal_lb_ip
  ports                 = [var.service_port]
  ip_protocol           = "TCP"
  network               = var.network
  subnetwork            = var.subnetwork
}



resource "google_compute_health_check" "pythonapp" {
  name                = "${var.name}-health-check-tcp-${var.env}"
  timeout_sec         = 1
  check_interval_sec  = 1
  healthy_threshold   = 3
  unhealthy_threshold = 3

  http_health_check {
    request_path       = "/"
    port               = var.health_port
    port_specification = "USE_FIXED_PORT"
  }
}

resource "google_compute_region_backend_service" "internal" {
  name          = "${var.name}-${var.env}-internal"
  health_checks = [google_compute_health_check.pythonapp.self_link]
  region        = var.region
  protocol      = "TCP"

  backend {
    group = var.instance_group
  }
}

resource "google_compute_target_pool" "pythonapp-pool" {
  name             = "${var.name}-${var.env}"
  region           = var.region
  session_affinity = var.session_affinity

  health_checks = [
    google_compute_http_health_check.pythonapp.name,
  ]
}

resource "google_compute_http_health_check" "pythonapp" {
  name                = "${var.name}-health-check-${var.env}"
  timeout_sec         = 1
  check_interval_sec  = 1
  healthy_threshold   = 3
  unhealthy_threshold = 3
  request_path        = "/"
  port                = var.health_port
}

resource "google_compute_firewall" "pythonapp-lb-fw" {
  name    = "${var.name}-firewall-${var.env}"
  network = var.network

  allow {
    protocol = "tcp"
    ports    = [var.service_port]
  }

  allow {
    protocol = "tcp"
    ports    = [var.health_port]
  }

  target_tags = ["pythonapp-pool"]
}
