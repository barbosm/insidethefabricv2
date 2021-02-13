# Provider
terraform {
  required_version = ">=0.12.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 3.52.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0.0"
    }
    template = {
      source  = "hashicorp/template"
      version = "~> 2.2.0"
    }
  }
}

provider "google" {
  project = var.project
  region  = var.region
  zone    = var.zone
}


# VPC
resource "google_compute_network" "public" {
  name                    = var.network_public_name
  auto_create_subnetworks = false
}

resource "google_compute_network" "private" {
  name                    = var.network_private_name
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "public" {
  name                     = var.subnet_public_name
  region                   = var.region
  network                  = google_compute_network.public.name
  ip_cidr_range            = var.subnet_public
  private_ip_google_access = true
}

resource "google_compute_subnetwork" "private" {
  name          = var.subnet_private_name
  region        = var.region
  network       = google_compute_network.private.name
  ip_cidr_range = var.subnet_private
}

resource "google_compute_firewall" "public" {
  name    = var.sg_name_public
  network = google_compute_network.public.name

  allow {
    protocol = "tcp"
    ports    = ["22", "80", "443"]
  }

  allow {
    protocol = "icmp"
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["public"]
}

resource "google_compute_firewall" "private" {
  name    = var.sg_name_private
  network = google_compute_network.private.name

  allow {
    protocol = "all"
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["private"]
}


# Instance
resource "random_id" "this" {
  byte_length = 8
}

resource "google_compute_disk" "this" {
  name = "log-disk-${random_id.this.hex}"
  size = 30
  type = "pd-standard"
  zone = var.zone
}

data "template_file" "fgtvm" {
  template = file(var.bootstrap_fgtvm)
}

resource "google_compute_instance" "fgtvm" {
  name           = var.vm_name
  machine_type   = var.type
  zone           = var.zone
  can_ip_forward = "true"

  tags = ["public", "private"]

  boot_disk {
    initialize_params {
      image = var.image
    }
  }

  attached_disk {
    source = google_compute_disk.this.name
  }

  network_interface {
    subnetwork = google_compute_subnetwork.public.name
    access_config {
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.private.name
  }

  metadata = {
    user-data = data.template_file.fgtvm.rendered
  }

  service_account {
    scopes = ["userinfo-email", "compute-ro", "storage-ro"]
  }

}


# Outputs
output "FG_Public_IP" {
  value = google_compute_instance.fgtvm.network_interface.0.access_config.0.nat_ip
}

output "Username" {
  value = "admin"
}

output "Password" {
  value = google_compute_instance.fgtvm.instance_id
}
