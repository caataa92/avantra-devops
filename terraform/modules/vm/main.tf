data "google_compute_image" "os" {
family = var.image_family
project = var.image_project
}


locals {
ssh_pubkey = trimspace(file(var.ssh_pubkey_path))
}


resource "google_compute_instance" "vm" {
name = var.name
machine_type = var.machine_type
tags = ["ssh"]


boot_disk {
initialize_params {
size = var.disk_size_gb
image = data.google_compute_image.os.self_link
type = "pd-balanced"
}
}


network_interface {
network = var.network
subnetwork = var.subnetwork
access_config {}
}


metadata = {
# Create the admin user and inject SSH key
ssh-keys = "${var.ssh_user}:${local.ssh_pubkey}"
# Install python3 on first boot for Ansible
startup-script = <<-EOT
#!/bin/bash
set -eux
if command -v zypper >/dev/null 2>&1; then
zypper -n ref || true
zypper -n in -y python3 python3-pip
elif command -v yum >/dev/null 2>&1; then
yum -y install python3
elif command -v dnf >/dev/null 2>&1; then
dnf -y install python3
else
apt-get update || true
apt-get install -y python3 python3-apt
fi
echo "${var.ssh_user} ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/${var.ssh_user}
chmod 0440 /etc/sudoers.d/${var.ssh_user}
EOT
}
}