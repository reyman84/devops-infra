module "this" {
  source = "terraform-aws-modules/vpc/aws"

  name = var.VPC_NAME
  cidr = var.VpcCIDR

  azs             = var.azs
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets

  #enable_nat_gateway      = true
  #single_nat_gateway      = true
  enable_dns_hostnames    = true
  enable_dns_support      = true
  map_public_ip_on_launch = true

  tags = {
    Name    = var.VPC_NAME
    Project = var.PROJECT
  }
}

resource "aws_key_pair" "devops_project" {
  key_name   = "devops_project"
  public_key = file("key-files/devops_project.pub")
}
