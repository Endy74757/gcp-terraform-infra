#GCP provider
provider "google" {
    credentials = file(var.credentials)
    region      = var.region
}
