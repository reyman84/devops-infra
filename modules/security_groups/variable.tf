variable "vpc_id" {
  description = "VPC ID where security groups will be created"
  type        = string
}

variable "trusted_ip" {
  description = "Trusted IP for SSH / UI access"
  type        = string
}
