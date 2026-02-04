#!/bin/bash

# Grafana Enterprise Installation Script
# Standard paths: /etc/grafana (config), /var/lib/grafana (data)
# Version: 12.2.1

set -e

# Variables
GRAFANA_VERSION="12.2.1"
DOWNLOAD_URL="https://dl.grafana.com/grafana-enterprise/release/${GRAFANA_VERSION}/grafana-enterprise_${GRAFANA_VERSION}_18655849634_linux_amd64.deb"
DEB_FILE="grafana-enterprise_${GRAFANA_VERSION}_18655849634_linux_amd64.deb"
SERVICE="grafana-server"

# Update system
sudo apt update && sudo apt upgrade -y

# Install dependencies
sudo apt-get install -y adduser libfontconfig1 musl

# Download package
wget "${DOWNLOAD_URL}"

# Install package
sudo dpkg -i "${DEB_FILE}"

# Reload, enable, and start service
sudo systemctl daemon-reload
sudo systemctl enable "${SERVICE}"
sudo systemctl start "${SERVICE}"

echo "Grafana Enterprise installed successfully!"
echo " - Config: /etc/grafana/grafana.ini"
echo " - Data: /var/lib/grafana/"
echo " - Service: systemctl status ${SERVICE}"
echo "Access Grafana UI at http://GrafanaIP:3000 (default admin/admin)"