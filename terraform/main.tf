# Resolve the VPC by name (defaults to "default" via variables.tf)
data "google_compute_network" "net" {
  name = var.network_name
}

# Latest Ubuntu 24.04 LTS image
data "google_compute_image" "ubuntu" {
  family  = "ubuntu-2404-lts"
  project = "ubuntu-os-cloud"
}


# Firewall: no semicolons in HCL; use newlines
resource "google_compute_firewall" "allow_ssh" {
  name    = "allow-ssh"
  network = data.google_compute_network.net.name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = var.open_ssh_cidr
  target_tags   = ["ssh"]
}

# SSH metadata from your local public key
locals {
  ssh_key  = chomp(file(var.public_ssh_key_path))
  ssh_meta = "${var.ssh_user}:${local.ssh_key}"
}

resource "google_compute_instance" "vm" {
  name         = var.vm_name
  machine_type = var.machine_type
  tags         = ["ssh"]

  boot_disk {
      initialize_params {
        image = data.google_compute_image.ubuntu.self_link
        size  = 20
        type  = "pd-balanced"
      }
}

  network_interface {
    network       = data.google_compute_network.net.name
    access_config {} # ephemeral public IP
  }

  metadata = {
    ssh-keys       = local.ssh_meta
    startup-script = <<-EOT
      #!/usr/bin/env bash
      apt-get update -y
      apt-get install -y nginx
      systemctl enable --now nginx || true
    EOT
  }

  service_account {
    scopes = ["https://www.googleapis.com/auth/cloud-platform"]
  }
}
