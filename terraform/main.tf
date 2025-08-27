terraform {
  required_version = ">= 1.5.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}

provider "google" {
  project = "crafty-chiller-469818-t9"       # your Project ID
  region  = "europe-west4"
  zone    = "europe-west4-a"
  # Uses Application Default Credentials from: gcloud auth application-default login
}

# Optional: open SSH (tighten source_ranges to your IP/CIDR)
resource "google_compute_firewall" "allow_ssh" {
  name    = "allow-ssh"
  network = "default"
  allow { protocol = "tcp"; ports = ["22"] }
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["ssh"]
}

# Read your public key and attach to metadata
locals {
  ssh_user = "ubuntu" # login name you’ll use with ssh
  ssh_key  = trimspace(file("~/.ssh/id_ed25519.pub"))
  ssh_meta = "${local.ssh_user}:${local.ssh_key}"
}

resource "google_compute_instance" "vm" {
  name         = "demo-vm"
  machine_type = "e2-medium"
  zone         = "europe-west4-a"
  tags         = ["ssh"]

  boot_disk {
    initialize_params {
      # Change image if you want Ubuntu: "ubuntu-os-cloud/ubuntu-2404-lts"
      image = "projects/ubuntu-os-cloud/global/images/family/ubuntu-2404-lts""
      size  = 20
      type  = "pd-balanced"
    }
  }

  network_interface {
    network = "default"
    access_config {} # gives an ephemeral public IP
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

output "public_ip"   { value = google_compute_instance.vm.network_interface[0].access_config[0].nat_ip }
output "ssh_command" { value = "ssh ${local.ssh_user}@${google_compute_instance.vm.network_interface[0].access_config[0].nat_ip}" }
