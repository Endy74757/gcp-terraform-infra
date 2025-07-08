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

variable "region" {}
