#!/bin/bash
set -euxo pipefail
exec > /var/log/user-data.log 2>&1

######################################
# Customize prompt
######################################
echo "PS1='\[\e[0;32m\]\u\[\e[0m\]@\[\e[0;35m\]\h\[\e[0m\]:\[\e[1;34m\]\w\[\e[0m\]\$ '" >> /root/.bashrc
sudo -u ubuntu bash -c 'echo "PS1=\"\[\e[0;32m\]\u\[\e[0m\]@\[\e[0;35m\]\h\[\e[0m\]:\[\e[1;34m\]\w\[\e[0m\]\$ \"" >> ~/.bashrc'

hostnamectl set-hostname ansible-controller

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
PASSWORD="Khalsa_1699"
HOME_DIR="/home/${USERNAME}"

if ! id "${USERNAME}" &>/dev/null; then
  useradd -m -s /bin/bash "${USERNAME}"
fi

echo "${USERNAME}:${PASSWORD}" | chpasswd
usermod -aG sudo "${USERNAME}"

######################################
# SSH keys for ansible user
######################################
mkdir -p ${HOME_DIR}/.ssh
chmod 700 ${HOME_DIR}/.ssh
chown -R ${USERNAME}:${USERNAME} ${HOME_DIR}/.ssh

sudo -u ${USERNAME} ssh-keygen -t rsa -b 4096 \
  -f ${HOME_DIR}/.ssh/id_rsa \
  -N "" \
  -C "ansible@controller"

chmod 600 ${HOME_DIR}/.ssh/id_rsa
chmod 644 ${HOME_DIR}/.ssh/id_rsa.pub
chown ${USERNAME}:${USERNAME} ${HOME_DIR}/.ssh/id_rsa*

######################################
# Python + Ansible dependencies
######################################
apt install -y python3 python3-pip python3-venv build-essential software-properties-common

######################################
# Create Ansible venv as ansible user
######################################
sudo -u ${USERNAME} bash << 'EOF'
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

echo "Ansible controller bootstrap completed"
