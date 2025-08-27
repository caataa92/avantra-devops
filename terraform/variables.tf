variable "vm_name" {
  type    = string
  default = "demo-vm"
}

variable "machine_type" {
  type    = string
  default = "e2-medium"
}

variable "network_name" {
  type    = string
  default = "default"
}

variable "public_ssh_key_path" {
  type    = string
  default = "~/.ssh/id_ed25519.pub"
}

variable "ssh_user" {
  type    = string
  default = "ubuntu"
}

variable "open_ssh_cidr" {
  type    = list(string)
  default = ["0.0.0.0/0"]  # tighten to your IP/CIDR in real setups
}
