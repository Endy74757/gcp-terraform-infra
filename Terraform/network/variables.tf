variable "project_id" {
  type = string
}

variable "network_name" {
  default = "devops-network"
}

variable "subnets" {
  type = map(object({
    cidr_range = string
  }))
}

variable "firewalls" {
  type = map(object({
    protocol = string
    ports    = list(string)
    description = string
    src = list(string)
    dest = optional(list(string),null)
  }))
}

variable "region" {}
