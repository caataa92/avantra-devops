#!/usr/bin/env bash
set -euo pipefail
ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT_DIR/terraform"


HOST_IP=$(terraform output -raw vm_external_ip)
SSH_USER=$(terraform output -raw vm_ssh_user)


mkdir -p "$ROOT_DIR/ansible/inventory"
cat > "$ROOT_DIR/ansible/inventory/hosts.ini" <<EOF
[sap_vms]
$HOST_IP ansible_user=$SSH_USER ansible_ssh_private_key_file=~/.ssh/id_rsa ansible_python_interpreter=/usr/bin/python3
EOF


echo "Inventory written to ansible/inventory/hosts.ini"