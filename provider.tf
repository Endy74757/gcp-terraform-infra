#GCP provider
provider "google" {
    credentials = var.credentials != null ? file(var.credentials) : null
    region      = var.region
}
