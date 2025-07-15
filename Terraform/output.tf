# output "subnet_map" {
#   description = "ข้อมูล subnet ทั้งหมดจาก module network"
#   value       = module.network.subnet_map
# }

output "vms_grouped_by_subnet" {
  description = "แสดงรายชื่อ VM และ internal_ip โดยจัดกลุ่มตามชื่อ Subnet"
  value       = module.compute.vms_by_subnet
}