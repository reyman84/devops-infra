##########################################
#           Security Group Outputs
##########################################

/*output "allow_all_sg_id" {
  description = "Allow all traffic security group ID"
  value       = aws_security_group.allow_all.id
}*/

output "ssh_sg_id" {
  description = "SSH security group ID"
  value       = aws_security_group.ssh.id
}

output "grafana_sg_id" {
  description = "grafana security group ID"
  value       = aws_security_group.grafana.id
}

output "prometheus_sg_id" {
  description = "prometheus security group ID"
  value       = aws_security_group.prometheus.id
}

output "loki_sg_id" {
  description = "loki security group ID"
  value       = aws_security_group.loki.id
}

output "webApp_sg_id" {
  description = "Security Group ID for Web Application"
  value       = aws_security_group.webApp.id
}


/*output "jenkins_master_sg_id" {
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
}*/
