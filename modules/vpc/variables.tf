variable "VPC_NAME" {
  type = string
}

variable "VpcCIDR" {
  type = string
}

variable "azs" {
  type = list(string)
}

variable "public_subnets" {
  type = list(string)
}

variable "private_subnets" {
  type = list(string)
}

variable "PROJECT" {
  type = string
}
