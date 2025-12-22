##########################################
#               VPC Outputs
##########################################

output "vpc_id" {
  description = "VPC ID"
  value       = module.this.vpc_id
}

output "public_subnets" {
  description = "Public subnet IDs"
  value       = module.this.public_subnets
}

output "private_subnets" {
  description = "Private subnet IDs"
  value       = module.this.private_subnets
}