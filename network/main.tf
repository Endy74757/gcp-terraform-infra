resource "google_compute_network" "vpc_network" {
    project = var.project_id
    name                    = var.network_name
    auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "vpc_subnets" {
    project = var.project_id
    for_each               = var.subnets
    name                   = each.key
    ip_cidr_range          = each.value.cidr_range
    region                 = var.region
    network                = google_compute_network.vpc_network.id
    depends_on = [ google_compute_network.vpc_network ]
}