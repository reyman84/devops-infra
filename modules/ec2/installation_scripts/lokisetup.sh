#!/bin/bash

# Loki Installation Script
# Standard paths: /etc/loki (config), /var/lib/loki (data)
# Version: 3.5.7 (latest as of November 2025)

set -e

# Variables
LOKI_VERSION="3.5.7"
DOWNLOAD_URL="https://github.com/grafana/loki/releases/download/v${LOKI_VERSION}/loki-linux-amd64.zip"
ZIP_FILE="loki-linux-amd64.zip"
BINARY="loki-linux-amd64"
WORK_DIR="/tmp/lok"
CONFIG_DIR="/etc/loki"
DATA_DIR="/var/lib/loki"
BIN_DIR="/usr/local/bin"
SERVICE_FILE="/etc/systemd/system/loki.service"

# Create working directory
mkdir -p "${WORK_DIR}"
cd "${WORK_DIR}"

# Install unzip if needed (assumes Debian/Ubuntu)
sudo apt install unzip -y

# Download and extract
wget "${DOWNLOAD_URL}"
unzip "${ZIP_FILE}"

# Move binary
sudo mv "${BINARY}" "${BIN_DIR}/loki"
sudo chmod +x "${BIN_DIR}/loki"

# Check version
loki --version

# Create group and user
groupadd --system loki
useradd --system --no-create-home --shell /sbin/nologin --gid loki loki

# Create data directories
sudo mkdir -p "${DATA_DIR}/chunks" "${DATA_DIR}/rules"
sudo chown -R loki:loki "${DATA_DIR}"
sudo chmod -R 755 "${DATA_DIR}"

# Create config directory
sudo mkdir -p "${CONFIG_DIR}"

# Create config file
sudo cat <<EOF > "${CONFIG_DIR}/config.yml"
auth_enabled: false

server:
  http_listen_port: 3100

common:
  path_prefix: /var/lib/loki
  storage:
    filesystem:
      chunks_directory: /var/lib/loki/chunks
      rules_directory: /var/lib/loki/rules
  replication_factor: 1
  ring:
    kvstore:
      store: inmemory

schema_config:
  configs:
    - from: 2023-01-01
      store: tsdb
      object_store: filesystem
      schema: v13
      index:
        prefix: index_
        period: 24h

limits_config:
  allow_structured_metadata: false
EOF

# Set ownership for config
sudo chown -R loki:loki "${CONFIG_DIR}"

# Create systemd service file
sudo cat <<EOF > "${SERVICE_FILE}"
[Unit]
Description=Loki Log Aggregation
After=network.target

[Service]
User=loki
Group=loki
Type=simple
ExecStart=/usr/local/bin/loki --config.file=/etc/loki/config.yml
Restart=on-failure
LimitNOFILE=65536

[Install]
WantedBy=multi-user.target
EOF

# Allow firewall port
sudo ufw allow 3100/tcp

# Reload and start service
sudo systemctl daemon-reload
sudo systemctl enable loki
sudo systemctl start loki
sudo systemctl status loki --no-pager

# Wait and verify
sleep 120
curl http://localhost:3100/ready

curl -s http://localhost:3100/metrics | grep loki_build_info