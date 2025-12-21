output "public_ip" {
  description = "Public IPs of EC2 instances"
  value       = aws_instance.this[*].public_ip
}

output "private_ip" {
  description = "Private IPs of EC2 instances"
  value       = aws_instance.this[*].private_ip
}

output "instance_ids" {
  description = "EC2 instance IDs"
  value       = aws_instance.this[*].id
}
