output "ansible_private_ips" {
  value = {
    for k, m in module.ansible :
    k => m.private_ip
  }
}

output "ansible_public_ips" {
  value = {
    for k, m in module.ansible :
    k => m.public_ip
  }
}