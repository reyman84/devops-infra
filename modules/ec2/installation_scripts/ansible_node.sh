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

# Detect OS and assign sudo group
if grep -qi "amazon linux" /etc/os-release; then
    SUDO_GROUP="wheel"
elif grep -qi "ubuntu" /etc/os-release; then
    SUDO_GROUP="sudo"
else
    echo "Unknown OS, defaulting to sudo group"
    SUDO_GROUP="sudo"
fi

# Create user if not exists
id $USERNAME &>/dev/null || useradd -m -s /bin/bash $USERNAME

# Add user to correct group and setup sudoers
usermod -aG $SUDO_GROUP $USERNAME
echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/ansible
chmod 440 /etc/sudoers.d/ansible

# SSH
mkdir -p /home/$USERNAME/.ssh
##############################
# Yet to fix public key issue
##############################
#cat <<EOF > /home/$USERNAME/.ssh/authorized_keys
#${ansible_public_key}
#EOF
chown -R $USERNAME:$USERNAME /home/$USERNAME/.ssh
chmod 700 /home/$USERNAME/.ssh
chmod 600 /home/$USERNAME/.ssh/authorized_keys

# Customize prompt idempotently
grep -q "PS1=.*\\u@" /home/$USERNAME/.bashrc || \
sudo -u $USERNAME bash -c 'echo "PS1=\"\[\e[0;32m\]\u\[\e[0m\]@\[\e[0;35m\]\h\[\e[0m\]:\[\e[1;34m\]\w\[\e[0m\]\$ \"" >> ~/.bashrc'

echo "Node ready"
