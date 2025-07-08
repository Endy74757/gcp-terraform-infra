
module "service" {
  source = "./Service"
  project_id = var.project_id
  services = var.services
}

module "network" {
  source = "./network"
  network_name = var.network_name
  project_id = var.project_id
  region = var.region
  subnets = var.subnets_config
  depends_on = [
    module.service
  ]
}

module "compute" {
  source         = "./compute"
  project_id     = var.project_id
  region         = var.region
  instance_configs = var.instance_configs
  subnet_map     = module.network.subnet_map
}
