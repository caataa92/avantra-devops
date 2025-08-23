variable "project_id" { type = string }
variable "region" { type = string }
variable "zone" { type = string }


variable "network_name" { type = string default = "sap-net" }
variable "subnet_ip_cidr_range" { type = string default = "10.20.0.0/24" }


variable "vm_name" { type = string default = "sap-vm-1" }
variable "vm_machine_type" { type = string default = "n2-standard-16" }
variable "vm_disk_size_gb" { type = number default = 512 }


# Image parameters (choose SLES for SAP or RHEL for SAP projects)
variable "image_project" { type = string default = "suse-sap-cloud" }
variable "image_family" { type = string default = "sles-15-sp5-sap-byos" }


variable "ssh_user" { type = string default = "sapadmin" }
variable "ssh_pubkey_path" { type = string default = "~/.ssh/id_rsa.pub" }