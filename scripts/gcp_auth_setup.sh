#!/usr/bin/env bash
set -euo pipefail

# Login interactively and set default project & region/zone
if ! command -v gcloud >/dev/null 2>&1; then
echo "gcloud CLI not found. Install from https://cloud.google.com/sdk/docs/install" >&2
exit 1
fi

gcloud auth login


echo "Enter your GCP Project ID:"; read -r PROJECT_ID


gcloud config set project "$PROJECT_ID"


echo "Enter default compute region (e.g. europe-west1):"; read -r REGION


gcloud config set compute/region "$REGION"


echo "Enter default compute zone (e.g. europe-west1-b):"; read -r ZONE


gcloud config set compute/zone "$ZONE"


# Create a service account & key for Terraform (optional but recommended)
echo "Create service account for Terraform? [y/N]"; read -r CREATE_SA
if [[ ${CREATE_SA,,} == "y" ]]; then
SA_NAME="tf-automation"
gcloud iam service-accounts create "$SA_NAME" --display-name "Terraform Automation"
gcloud projects add-iam-policy-binding "$PROJECT_ID" \
--member "serviceAccount:${SA_NAME}@${PROJECT_ID}.iam.gserviceaccount.com" \
--role roles/editor
gcloud iam service-accounts keys create "${SA_NAME}.json" \
--iam-account "${SA_NAME}@${PROJECT_ID}.iam.gserviceaccount.com"
echo "Export this before running Terraform:"
echo "export GOOGLE_APPLICATION_CREDENTIALS=$(pwd)/${SA_NAME}.json"
fi