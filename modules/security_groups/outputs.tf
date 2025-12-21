##########################################
#           Security Group Outputs
##########################################

output "allow_all_sg_id" {
  description = "Allow all traffic security group ID"
  value       = aws_security_group.allow_all.id
}

output "ssh_sg_id" {
  description = "SSH security group ID"
  value       = aws_security_group.ssh.id
}

output "jenkins_master_sg_id" {
  description = "Jenkins master security group ID"
  value       = aws_security_group.jenkins_master.id
}

output "nexus_sg_id" {
  description = "Nexus security group ID"
  value       = aws_security_group.nexus.id
}

output "sonarqube_sg_id" {
  description = "SonarQube security group ID"
  value       = aws_security_group.sonarqube.id
}
