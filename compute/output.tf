output "vm_ips" {
  value = {
    for name, inst in google_compute_instance.vm :
    name => {
      internal_ip = inst.network_interface[0].network_ip
      external_ip = length(inst.network_interface[0].access_config) > 0 ? inst.network_interface[0].access_config[0].nat_ip : "none"
    }
  }
}
