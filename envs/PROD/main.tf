resource "aws_key_pair" "prod" {
  key_name   = "prod_key"
  public_key = file("${path.module}/keypair/prod_key.pub")

  tags = {
    Name  = "prod_key"
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

module "docker" {
  source = "../../modules/ec2"

  name               = "${var.PROJECT}-ec2"
  ami_id             = data.aws_ami.ubuntu_24.id
  instance_type      = var.instance_type
  key_name           = aws_key_pair.prod.key_name
  subnet_ids         = module.vpc.public_subnets
  security_group_ids = [module.security_groups.ssh_sg_id, module.security_groups.allow_all_sg_id]

  user_data = file("../../modules/ec2/installation_scripts/docker_install.sh")
}
