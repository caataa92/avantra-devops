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
  project = "crafty-chiller-469818-t9"  # <-- your Project ID
  region  = "europe-west4"
  zone    = "europe-west4-a"
}
