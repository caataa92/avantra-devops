resource "google_compute_network" "vpc" {
name = var.network_name
auto_create_subnetworks = false
}


resource "google_compute_subnetwork" "subnet" {
name = "${var.network_name}-subnet"
ip_cidr_range = var.subnet_ip_cidr_range
region = var.region
network = google_compute_network.vpc.id
}


resource "google_compute_firewall" "ssh_ingress" {
name = "allow-ssh"
network = google_compute_network.vpc.name


allow { protocol = "tcp" ports = ["22"] }
source_ranges = ["0.0.0.0/0"]
target_tags = ["ssh"]
}


module "vm" {
source = "./modules/vm"
name = var.vm_name
machine_type = var.vm_machine_type
disk_size_gb = var.vm_disk_size_gb
network = google_compute_network.vpc.name
subnetwork = google_compute_subnetwork.subnet.name
image_project = var.image_project
image_family = var.image_family
ssh_user = var.ssh_user
ssh_pubkey_path = var.ssh_pubkey_path
}