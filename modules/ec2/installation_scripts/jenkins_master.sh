#!/bin/bash

# --- Logging --- #
exec > >(tee /var/log/user-data.log)
exec 2>&1
set -euxo pipefail

# --- Update OS --- #
apt update -y
apt install -y curl unzip gnupg fontconfig ca-certificates apt-transport-https

# --- Install AWS CLI v2 --- #
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
aws --version

# --- Install Java 21 --- #
apt install -y openjdk-21-jdk
java -version

# Set JAVA_HOME globally --- # 
echo 'export JAVA_HOME=/usr/lib/jvm/java-21-openjdk-amd64' | sudo tee -a /etc/profile
echo 'export PATH=$PATH:$JAVA_HOME/bin' | sudo tee -a /etc/profile
   
# Apply JAVA_HOME for current session --- #
export JAVA_HOME=/usr/lib/jvm/java-21-openjdk-amd64
export PATH=$PATH:$JAVA_HOME/bin

# --- Install Jenkins Repository --- #
# Jenkins Key
mkdir -p /etc/apt/keyrings

gpg --keyserver keyserver.ubuntu.com \
    --recv-keys 7198F4B714ABFC68

gpg --export 7198F4B714ABFC68 \
| gpg --dearmor \
> /etc/apt/keyrings/jenkins.gpg

# Jenkins Repository
echo "deb [signed-by=/etc/apt/keyrings/jenkins.gpg] https://pkg.jenkins.io/debian-stable binary/" \
> /etc/apt/sources.list.d/jenkins.list

# Verify
cat /etc/apt/sources.list.d/jenkins.list
gpg --show-keys /etc/apt/keyrings/jenkins.gpg


# --- Install Jenkins --- #
apt-get update -y
apt-get install -y jenkins

# --- Start Jenkins --- #
systemctl daemon-reload
systemctl enable jenkins
systemctl start jenkins
systemctl status jenkins --no-pager

# --- Set Hostname --- #
hostnamectl set-hostname jenkins-master

# Enable password authentication for SSH (required for Jenkins Slave connection)
sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/g' /etc/ssh/sshd_config
sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config.d/*.conf
systemctl restart ssh

# --- Customize root prompt --- #
echo "PS1='\[\e[0;32m\]\u\[\e[0m\]@\[\e[0;35m\]\h\[\e[0m\]:\[\e[1;34m\]\w\[\e[0m\]\$ '" >> /root/.bashrc

# --- Customize ubuntu prompt --- #
sudo -u ubuntu bash -c 'echo "PS1=\"\[\e[0;32m\]\u\[\e[0m\]@\[\e[0;35m\]\h\[\e[0m\]:\[\e[1;34m\]\w\[\e[0m\]\$ \"" >> ~/.bashrc'

# --- Jenkins Initial Password --- #
echo "Jenkins initial password:"
cat /var/lib/jenkins/secrets/initialAdminPassword
