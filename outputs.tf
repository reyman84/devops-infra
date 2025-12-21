##########################################
#          Docker EC2 Outputs
##########################################
/*output "docker_private_ip" {
  description = "Private IP of Docker instance(s)"
  value       = module.docker.private_ip
}

/*output "docker_public_ip" {
  description = "Public IP of Docker instance(s)"
  value       = module.docker.public_ip
}*/

##########################################
#          Minikube EC2 Outputs
##########################################
/*output "minikube_private_ip" {
  description = "Private IP of Minikube instance(s)"
  value       = module.minikube.private_ip
}

/*output "minikube_public_ip" {
  description = "Public IP of Minikube instance(s)"
  value       = module.minikube.public_ip
}*/

##########################################
#          Kubernetes Cluster Outputs
##########################################
/*output "k8s_cluster_private_ips" {
  description = "Private IPs of Kubernetes cluster nodes"
  value       = module.k8s_cluster.private_ip
}

/*output "k8s_cluster_public_ips" {
  description = "Public IPs of Kubernetes cluster nodes"
  value       = module.k8s_cluster.public_ip
}*/

##########################################
#          Jenkins Master Outputs
##########################################
/*output "jenkins_master_private_ip" {
  description = "Private IP of Jenkins Master"
  value       = module.jenkins_master.private_ip
}

/*output "jenkins_master_public_ip" {
  description = "Public IP of Jenkins Master"
  value       = module.jenkins_master.public_ip
}*/

##########################################
#          Jenkins Slave Outputs
##########################################
/*output "jenkins_slave_private_ip" {
  description = "Private IP of Jenkins Slave"
  value       = module.jenkins_slave.private_ip
}

/*output "jenkins_slave_public_ip" {
  description = "Public IP of Jenkins Slave"
  value       = module.jenkins_slave.public_ip
}*/

##########################################
#          Nexus Outputs
##########################################
/*output "nexus_private_ip" {
  description = "Private IP of Nexus server"
  value       = module.nexus.private_ip
}

/*output "nexus_public_ip" {
  description = "Public IP of Nexus server"
  value       = module.nexus.public_ip
}*/

##########################################
#          SonarQube Outputs
##########################################
/*output "sonarqube_private_ip" {
  description = "Private IP of SonarQube server"
  value       = module.sonarqube.private_ip
}

/*output "sonarqube_public_ip" {
  description = "Public IP of SonarQube server"
  value       = module.sonarqube.public_ip
}*/
