#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/../terraform"


terraform init
terraform validate
terraform plan -out tfplan
terraform apply -auto-approve tfplan