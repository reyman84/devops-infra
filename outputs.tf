###########
# ansible #
###########

output "ansible_private_ip" {
  value = module.ansible.private_ip
}

output "ansible_public_ip" {
  value = module.ansible.public_ip
}

###########
#  docker #
###########
/*output "docker_private" {
  value = module.docker.private_ip
}

output "docker_public" {
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