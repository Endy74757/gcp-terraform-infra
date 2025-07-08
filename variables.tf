variable "project_id" {
    type = string
}

variable "credentials" {
    type = string
}

variable "region" {
  default = "asia-southeast1"
}

variable "instance_configs" {
  type = map(object({
    zone         = string
    machine_type = string
    subnet       = string
    assign_public_ip = optional(bool, false)
  }))
}

variable "subnets_config" {
  type = map(object({
    cidr_range = string
  }))
}

variable "services" {
  type = list(string)
}

variable "network_name" {
  default = "devops-network"
}