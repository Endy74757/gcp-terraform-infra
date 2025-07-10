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

resource "google_compute_firewall" "firewall-1" {
    for_each = var.firewalls
    name    = each.key
    project = var.project_id
    network = google_compute_network.vpc_network.name
    description = each.value.description

    allow {
        protocol = each.value.protocol
        ports    = each.value.ports
    }
    source_ranges = each.value.src
    destination_ranges = each.value.dest
    depends_on = [ google_compute_network.vpc_network ]
}
