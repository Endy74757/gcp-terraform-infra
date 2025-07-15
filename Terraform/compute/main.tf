resource "google_compute_instance" "vm" {
  for_each     = var.instance_configs
  project      = var.project_id
  name         = each.key
  machine_type = each.value.machine_type
  zone         = each.value.zone
  can_ip_forward = each.value.ip_forward
  labels = {
    role = each.key
  }

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2204-lts"
    }
  }

  network_interface {
    network    = var.subnet_map[each.value.subnet].network
    subnetwork = var.subnet_map[each.value.subnet].name
    subnetwork_project = var.project_id
    dynamic "access_config" {
      for_each = each.value.assign_public_ip ? [1] : []
      content {}
    }
    
  }

  tags = [each.value.subnet]
}
