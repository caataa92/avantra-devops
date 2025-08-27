# avantra-devops
Automatization for AIOps Platform

# GCP + Terraform + Ansible Starter for SAP Test Environments

This repo boots a GCP VM via Terraform, then configures it with Ansible to prepare OS prerequisites and (optionally) install SAP HANA / S/4HANA components and the Avantra agent.


## Prereqs
- Google Cloud account + project.
- `gcloud` CLI installed and authenticated (`scripts/gcp_auth_setup.sh`).
- Terraform >= 1.6.
- Ansible >= 2.15 on your laptop.


## Quick Start
1. **Authenticate to GCP**
```bash
./scripts/gcp_auth_setup.sh