#!/bin/bash

######################################
# Install packages, in Amazon-linux
######################################
yum install -y vim > /dev/null

######################################
# Customize prompt
######################################
echo "PS1='\[\e[0;32m\]\u\[\e[0m\]@\[\e[0;35m\]\h\[\e[0m\]:\[\e[1;34m\]\w\[\e[0m\]\$ '" >> /root/.bashrc
sudo -u ec2-user bash -c 'echo "PS1=\"\[\e[0;32m\]\u\[\e[0m\]@\[\e[0;35m\]\h\[\e[0m\]:\[\e[1;34m\]\w\[\e[0m\]\$ \"" >> ~/.bashrc'
sudo -u ubuntu bash -c 'echo "PS1=\"\[\e[0;32m\]\u\[\e[0m\]@\[\e[0;35m\]\h\[\e[0m\]:\[\e[1;34m\]\w\[\e[0m\]\$ \"" >> ~/.bashrc'

######################################
# Create 'ansible' user
######################################

USERNAME="ansible"
PASSWORD="Khalsa_1699"

# Check if user already exists
if id "$USERNAME" &>/dev/null; then
    echo "User '$USERNAME' already exists"
else
    # Create user with home directory and bash shell
    useradd -m -s /bin/bash "$USERNAME"
    echo "User '$USERNAME' created"
fi

# Set password
echo "$USERNAME:$PASSWORD" | chpasswd
echo "Password set for user '$USERNAME'"

# OPTIONAL: Add user to sudo group
usermod -aG sudo "$USERNAME"
echo "User '$USERNAME' added to sudo group"

