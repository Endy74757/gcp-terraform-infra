variable "project_id" {
  type = string
}
variable "region" {}
variable "instance_configs" {
  type = map(object({
    zone         = string
    machine_type = string
    subnet       = string
    ip_forward = optional(bool, false)
    assign_public_ip = optional(bool, false)
  }))
}

variable "subnet_map" {
  type = map(object({
    name      = string
    region    = string
    network   = string
    self_link = string
  }))
}
