#!/bin/bash
set -euxo pipefail
exec > /var/log/user-data.log 2>&1

# --- Customize prompt ---
echo "PS1='\[\e[0;32m\]\u\[\e[0m\]@\[\e[0;35m\]\h\[\e[0m\]:\[\e[1;34m\]\w\[\e[0m\]\$ '" >> /root/.bashrc
sudo -u ubuntu bash -c 'echo "PS1=\"\[\e[0;32m\]\u\[\e[0m\]@\[\e[0;35m\]\h\[\e[0m\]:\[\e[1;34m\]\w\[\e[0m\]\$ \"" >> ~/.bashrc'

# Hostname
hostnamectl set-hostname ansible-controller

######################################
#  Ansible installation using "pip"  #
######################################

# Update system
apt-get update -y

# Install dependencies
apt-get install -y python3 python3-pip python3-venv build-essential software-properties-common

# Create working dir
mkdir -p /root/ansible
cd /root/ansible

# Create venv (NO virtualenv command)
python3 -m venv DEV

# Install ansible INSIDE venv (NO source)
./DEV/bin/pip install --upgrade pip
./DEV/bin/pip install ansible

# Verify explicitly
./DEV/bin/ansible --version
