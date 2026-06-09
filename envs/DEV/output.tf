output "jenkins_public_ip" {
  value = module.jenkins_master.public_ip
}

/*output "controller_private_ip" {
  value = module.controller.private_ip
}

output "controller_public_ip" {
  value = module.controller.public_ip
}

output "nodes_private_ips" {
  value = {
    for k, m in module.nodes :
    k => m.private_ip
  }
}

output "nodes_public_ips" {
  value = {
    for k, m in module.nodes :
    k => m.public_ip
  }
}

output "docker" {
  value = module.docker.public_ip
}*/
