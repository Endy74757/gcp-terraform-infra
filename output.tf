output "subnet_map" {
  description = "ข้อมูล subnet ทั้งหมดจาก module network"
  value       = module.network.subnet_map
}

output "vm_ips" {
  description = "IP address (internal และ external) ของแต่ละ VM"
  value       = module.compute.vm_ips
}