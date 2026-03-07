PROJECT = "vprofile_dev"
region  = "us-east-1"

# VPC
VpcCIDR  = "172.31.0.0/16"
VPC_NAME = "vprofile_dev"

# Availability Zones
Zone1 = "us-east-1a"
Zone2 = "us-east-1b"
Zone3 = "us-east-1c"

# Public Subnets
PubSub1CIDR = "172.31.10.0/24"
PubSub2CIDR = "172.31.20.0/24"
PubSub3CIDR = "172.31.30.0/24"

# Private Subnets
PrivSub1CIDR = "172.31.40.0/24"
PrivSub2CIDR = "172.31.50.0/24"
PrivSub3CIDR = "172.31.60.0/24"

# Instance Types
instance_type        = "t2.micro"
docker_instance_type = "t2.medium"

#Others
trusted_ip = "49.207.50.91/32"