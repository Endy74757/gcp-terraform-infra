resource "local_file" "ansible_inventory_ini" {
  filename = "../Ansible/inventory.ini"
  content = templatefile("${path.module}/templates/inventory.ini.tftpl", {
    vms_by_subnet = module.compute.vms_by_subnet
  })
}