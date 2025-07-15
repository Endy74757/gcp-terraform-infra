output "vms_by_subnet" {
  description = "VMs grouped by subnet, showing instance name and internal IP."
  value = {
    for subnet_name in distinct([for c in var.instance_configs : c.subnet]) :
    subnet_name => {
      for vm_name, vm in google_compute_instance.vm :
      vm_name => {
        internal_ip = vm.network_interface[0].network_ip
      }  if var.instance_configs[vm_name].subnet == subnet_name
    }
  }
}
