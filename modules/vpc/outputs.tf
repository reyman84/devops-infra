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

output "devops_key_name" {
  description = "EC2 key pair name"
  value       = aws_key_pair.devops_project.key_name
}
