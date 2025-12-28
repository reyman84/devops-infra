###########
# ansible #
###########

output "ansible" {
  value = module.ansible.private_ip
}

output "ansible" {
  value = module.ansible.public_ip
}

###########
#  docker #
###########
/*output "docker" {
  value = module.docker.private_ip
}

output "docker" {
  value = module.docker.public_ip
}

output "minikube" {
  value = module.minikube.public_ip
}

output "k8s_clusters" {
  value = module.k8s_cluster.public_ip
}

output "jenkins_master" {
  value = module.jenkins_master.public_ip
}

output "jenkins_slave" {
  value = module.jenkins_slave.public_ip
}

output "nexus" {
  value = module.nexus.public_ip
}

output "sonarqube" {
  value = module.sonarqube.public_ip
}*/