#!/bin/bash
set -euxo pipefail
exec > /var/log/user-data.log 2>&1

######################################
# Customize prompt
######################################
echo "PS1='\[\e[0;32m\]\u\[\e[0m\]@\[\e[0;35m\]\h\[\e[0m\]:\[\e[1;34m\]\w\[\e[0m\]\$ '" >> /root/.bashrc
sudo -u ubuntu bash -c 'echo "PS1=\"\[\e[0;32m\]\u\[\e[0m\]@\[\e[0;35m\]\h\[\e[0m\]:\[\e[1;34m\]\w\[\e[0m\]\$ \"" >> ~/.bashrc'

hostnamectl set-hostname controller

######################################
# Install AWS CLI
######################################
apt update -y
apt install -y curl unzip
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
./aws/install
aws --version

######################################
# Create ansible user
######################################
USERNAME="ansible"

id $USERNAME &>/dev/null || useradd -m -s /bin/bash ansible
usermod -aG sudo ansible

echo "ansible ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/ansible
chmod 440 /etc/sudoers.d/ansible
sudo -u $USERNAME bash -c 'echo "PS1=\"\[\e[0;32m\]\u\[\e[0m\]@\[\e[0;35m\]\h\[\e[0m\]:\[\e[1;34m\]\w\[\e[0m\]\$ \"" >> ~/.bashrc'

######################################
# SSH keys
######################################
sudo -u $USERNAME mkdir -p /home/$USERNAME/.ssh
sudo -u $USERNAME ssh-keygen -t rsa -b 4096 -f /home/$USERNAME/.ssh/id_rsa -N "" -C "ansible@controller"

chown -R $USERNAME:$USERNAME /home/$USERNAME/.ssh
chmod 700 /home/$USERNAME/.ssh
chmod 600 /home/$USERNAME/.ssh/id_rsa
chmod 644 /home/$USERNAME/.ssh/id_rsa.pub

######################################
# Python + Ansible dependencies
######################################
apt install -y python3 python3-pip python3-venv build-essential software-properties-common

######################################
# Create Ansible venv as ansible user
######################################
sudo -u $USERNAME bash << 'EOF'
set -euxo pipefail
cd ~

mkdir -p ansible
cd ansible

python3 -m venv DEV
source DEV/bin/activate

./DEV/bin/pip install --upgrade pip
./DEV/bin/pip install ansible

./DEV/bin/ansible --version

pip3 install boto3 botocore
python3 -c "import boto3; print('boto3 OK')"
EOF

######################################
# Bootstrap Ansible files (NO execution)
######################################
sudo -u ansible bash << 'EOF'
set -euxo pipefail

BASE=/home/ansible/ansible

mkdir -p $BASE/playbooks
mkdir -p $BASE/inventory

######################################
# ansible.cfg
######################################
cat << 'CFG' > $BASE/ansible.cfg
[defaults]
inventory = /home/ansible/ansible/inventory/aws_ec2.yaml
host_key_checking = false
remote_user = ansible
interpreter_python = /usr/bin/python3
deprecation_warnings = False

[inventory]
enable_plugins = host_list, ini, yaml, toml, script, auto
CFG

######################################
# aws_ec2 inventory
######################################

cat << 'YAML' > $BASE/inventory/aws_ec2.yaml
plugin: amazon.aws.aws_ec2

regions:
  - us-east-1

filters:
  instance-state-name: running
  "tag:Role":
    - dev
    - stage

hostnames:
  - private-dns-name

hostvars_prefix: ec2_

groups:
  dev: ec2_tags.Role == 'dev'
  stage: ec2_tags.Role == 'stage'
YAML

chown -R ansible:ansible $BASE
EOF

echo "Ansible controller bootstrap completed"