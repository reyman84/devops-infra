resource "aws_key_pair" "dev" {
  key_name   = "devops_project"
  public_key = file("${path.module}/keypair/devops_project.pub")

  tags = {
    Name = "dev_key"
  }
}

module "vpc" {
  source = "../../modules/vpc"

  VPC_NAME = var.VPC_NAME
  VpcCIDR  = var.VpcCIDR

  azs             = [var.Zone1, var.Zone2, var.Zone3]
  public_subnets  = [var.PubSub1CIDR, var.PubSub2CIDR, var.PubSub3CIDR]
  private_subnets = [var.PrivSub1CIDR, var.PrivSub2CIDR, var.PrivSub3CIDR]

  PROJECT = var.PROJECT
}

module "security_groups" {
  source     = "../../modules/security_groups"
  vpc_id     = module.vpc.vpc_id
  trusted_ip = var.trusted_ip
}

/*module "docker" {
  source = "../../modules/ec2"

  for_each = {
    #docker1 = module.vpc.public_subnets[0]
    #docker2 = module.vpc.public_subnets[1]
    #docker3 = module.vpc.public_subnets[2]
  }

  name               = "${var.PROJECT}-${each.key}"
  ami_id             = data.aws_ami.ubuntu_24.id
  instance_type      = var.instance_type
  key_name           = aws_key_pair.dev.key_name
  subnet_id          = each.value
  security_group_ids = [ module.security_groups.ssh_sg_id, module.security_groups.allow_all_sg_id ]

  user_data = file("../../modules/ec2/installation_scripts/docker_install.sh")
}*/

/*module "jenkins_master" {
  source = "../../modules/ec2"

  name               = "jenkins-master"
  ami_id             = data.aws_ami.ubuntu_24.id
  instance_type      = "t3.large"
  subnet_id          = module.vpc.public_subnets[0]
  security_group_ids = [module.security_groups.jenkins_sg_id]
  key_name           = aws_key_pair.dev.key_name

  instance_count = 1

  root_block_device = {
    volume_size = 50
    volume_type = "gp3"
  }

  ebs_block_devices = [
    {
      device_name = "/dev/sdf"
      volume_size = 150
      volume_type = "gp3"
    }
  ]

  user_data = file("jenkins_master.sh")
}


module "jenkins_agent" {
  source = "../../modules/ec2"

  name               = "jenkins-agent"
  ami_id             = data.aws_ami.ubuntu_24.id
  instance_type      = "t3.medium"
  subnet_id          = module.vpc.public_subnets[1]
  security_group_ids = [module.security_groups.jenkins_agent_sg_id]
  key_name           = aws_key_pair.dev.key_name

  instance_count = 2

  root_block_device = {
    volume_size = 40
    volume_type = "gp3"
  }

  ebs_block_devices = [
    {
      device_name = "/dev/sdf"
      volume_size = 80
      volume_type = "gp3"
    }
  ]

  user_data = file("jenkins_agent.sh")
}*/

module "ansible" {
  source = "../../modules/ec2"

  for_each = {
    ansible1 = module.vpc.public_subnets[0]
    #ansible2 = module.vpc.public_subnets[1]
    #ansible3 = module.vpc.public_subnets[2]
  }

  name               = "${var.PROJECT}-${each.key}"
  ami_id             = data.aws_ami.ubuntu_24.id
  instance_type      = var.instance_type
  key_name           = aws_key_pair.dev.key_name
  subnet_id          = each.value
  security_group_ids = [ module.security_groups.ssh_sg_id ]

  #user_data = file("../../modules/ec2/installation_scripts/docker_install.sh")
}