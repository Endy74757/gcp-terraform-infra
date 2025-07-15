output "subnet_map" {
  value = {
    for name, subnet in google_compute_subnetwork.vpc_subnets :
    name => {
      name    = subnet.name
      region  = subnet.region
      network = subnet.network
      self_link = subnet.self_link
    }
  }
}