variable "env" {
    type = string
    description = "Environment"
}

variable "vpc_cidr_block" {
    type = string
    description = "VPC CIDR"
    default = "192.168.0.0/16"
}

variable "azs" {
    type = list(string)
    description = "Availability Zones"
}

variable "public_subnets" {
    type = list(string)
    description = "Public Subnets CIDR Blocks"
}

variable "private_subnets" {
    type = list(string)
    description = "Private Subnets CIDR Blocks"
}
variable "public_subnets_tags" {
    type = map(string)
    description = "Public Subnets Tags"
}
variable "private_subnets_tags" {
    type = map(string)
    description = "Private Subnets Tags"
}
