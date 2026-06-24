provider "google" {
  project = var.gcp_project_id
  region  = var.gcp_region
}

resource "google_compute_network" "main" {
  name                    = "${var.project_name}-${var.environment}-vpc"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "private" {
  name          = "${var.project_name}-${var.environment}-private-subnet"
  ip_cidr_range = var.gcp_private_subnet_cidr
  region        = var.gcp_region
  network       = google_compute_network.main.id

  private_ip_google_access = true
}

resource "google_compute_firewall" "allow_https" {
  name    = "${var.project_name}-${var.environment}-allow-https"
  network = google_compute_network.main.name

  allow {
    protocol = "tcp"
    ports    = ["443"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["https"]
}

resource "google_storage_bucket" "evidence" {
  name                        = "${var.project_name}-${var.environment}-evidence"
  location                    = upper(var.gcp_region)
  uniform_bucket_level_access = true
  force_destroy               = true
}
