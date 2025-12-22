



/*module "docker" {
  source = "./modules/ec2"

  name           = "Docker-Engine"
  instance_count = 1
  ami_id         = data.aws_ami.ubuntu_24.id
  instance_type  = "t2.micro"
  key_name       = module.vpc.devops_key_name
  subnet_ids     = module.vpc.public_subnets

  security_group_ids = [
    module.security_groups.ssh_sg_id,
    module.security_groups.allow_all_sg_id
  ]

  user_data = file("modules/ec2/installation_scripts/docker_install.sh")
}

module "minikube" {
  source = "./modules/ec2"

  name           = "k8s-minikube"
  instance_count = 1
  ami_id         = data.aws_ami.ubuntu_24.id
  instance_type  = "t3.medium"
  key_name       = module.vpc.devops_key_name
  subnet_ids     = module.vpc.public_subnets

  security_group_ids = [
    module.security_groups.ssh_sg_id,
    module.security_groups.allow_all_sg_id
  ]

  user_data = file("modules/ec2/installation_scripts/minikube.sh")
}

module "k8s_cluster" {
  source = "./modules/ec2"

  name           = "k8s-node"
  instance_count = 1
  ami_id         = data.aws_ami.ubuntu_22.id
  instance_type  = "t3.medium"
  key_name       = module.vpc.devops_key_name
  subnet_ids     = module.vpc.public_subnets

  security_group_ids = [
    module.security_groups.ssh_sg_id,
    module.security_groups.allow_all_sg_id
  ]

  user_data = file("modules/ec2/installation_scripts/Create+K8s+HA+SetUp.sh")
}

module "jenkins_master" {
  source = "./modules/ec2"

  name           = "Jenkins-Master"
  instance_count = 1
  ami_id         = data.aws_ami.ubuntu_24.id
  instance_type  = "t2.small"
  key_name       = module.vpc.devops_key_name
  subnet_ids     = module.vpc.public_subnets
  #associate_public_ip = true

  security_group_ids = [
    module.security_groups.ssh_sg_id,
    module.security_groups.jenkins_master_sg_id
  ]

  # IAM instance profile is optional and handled in module
  # root_block_device handled inside module

  user_data = file("modules/ec2/installation_scripts/jenkins_master.sh")
}

module "jenkins_slave" {
  source = "./modules/ec2"

  name           = "Jenkins-Slave"
  instance_count = 1
  ami_id         = data.aws_ami.ubuntu_24.id
  instance_type  = "t2.small"
  key_name       = module.vpc.devops_key_name
  subnet_ids     = module.vpc.public_subnets

  security_group_ids = [
    module.security_groups.ssh_sg_id,
    module.security_groups.jenkins_master_sg_id
  ]

  ebs_block_devices = [
    {
      device_name = "/dev/sdf"
      volume_size = 2
      volume_type = "gp3"
    }
  ]

  user_data = file("modules/ec2/installation_scripts/jenkins_slave.sh")
}

module "nexus" {
  source = "./modules/ec2"

  name           = "Nexus-Server"
  instance_count = 1
  ami_id         = data.aws_ami.linux.id
  instance_type  = "t2.medium"
  key_name       = module.vpc.devops_key_name
  subnet_ids     = module.vpc.public_subnets

  security_group_ids = [
    module.security_groups.ssh_sg_id,
    module.security_groups.nexus_sg_id
  ]

  user_data = file("modules/ec2/installation_scripts/nexus-setup.sh")
}

module "sonarqube" {
  source = "./modules/ec2"

  name           = "SonarQube-Server"
  instance_count = 1
  ami_id         = data.aws_ami.ubuntu_24.id
  instance_type  = "t2.medium"
  key_name       = module.vpc.devops_key_name
  subnet_ids     = module.vpc.public_subnets

  security_group_ids = [
    module.security_groups.ssh_sg_id,
    module.security_groups.sonarqube_sg_id
  ]

  # Set root volume size via module variable
  root_block_device = {
    volume_size = 12
    volume_type = "gp3"
  }

  user_data = file("modules/ec2/installation_scripts/sonar-setup.sh")

  tags = {
    Role = "SonarQube"
  }
}*/