#!/bin/bash
#=============================================================
#  Node Setup Script for Monitoring Lecture Environment
#-------------------------------------------------------------
#  This script installs and configures:
#   1. Basic System Setup
#   2. Node Exporter (for Prometheus)
#   3. Titan App as a Service
#   4. Load generation scripts
#   5. Alloy (for metrics & logs collection)
#   6. Final Summary
#
#  Author: HKH Admin
#  Version: 2.0
#  Tested on: Ubuntu 22.04 LTS
#=============================================================

set -e  # Exit immediately if a command fails

#-------------------------------------------------------------
# 1. Basic System Setup
#-------------------------------------------------------------
echo "===== [1/6] Setting up basic system configuration ====="
echo "Setting hostname to web01..."
echo "web01" > /etc/hostname
hostname web01

echo "Updating and upgrading system packages..."
apt update -y && apt upgrade -y

echo "Installing essential utilities (zip, unzip, stress)..."
apt install -y zip unzip stress stress-ng

#-------------------------------------------------------------
# 2. Install and Configure Node Exporter
#-------------------------------------------------------------
echo "===== [2/6] Installing Prometheus Node Exporter ====="

mkdir -p /tmp/exporter
cd /tmp/exporter

NODE_VERSION="1.10.2"
echo "Downloading Node Exporter v${NODE_VERSION}..."
wget -q https://github.com/prometheus/node_exporter/releases/download/v${NODE_VERSION}/node_exporter-${NODE_VERSION}.linux-amd64.tar.gz

echo "Extracting Node Exporter..."
tar xzf node_exporter-${NODE_VERSION}.linux-amd64.tar.gz

echo "Moving binary to /var/lib/node..."
mkdir -p /var/lib/node
mv node_exporter-${NODE_VERSION}.linux-amd64/node_exporter /var/lib/node/

echo "Creating prometheus system user..."
groupadd --system prometheus || true
useradd -s /sbin/nologin --system -g prometheus prometheus || true

chown -R prometheus:prometheus /var/lib/node/
chmod -R 775 /var/lib/node

echo "Creating Node Exporter systemd service..."
cat <<EOF > /etc/systemd/system/node.service
[Unit]
Description=Prometheus Node Exporter
Documentation=https://prometheus.io/docs/introduction/overview/
Wants=network-online.target
After=network-online.target

[Service]
Type=simple
User=prometheus
Group=prometheus
ExecReload=/bin/kill -HUP \$MAINPID
ExecStart=/var/lib/node/node_exporter
SyslogIdentifier=prometheus_node_exporter
Restart=always

[Install]
WantedBy=multi-user.target
EOF

echo "Enabling and starting Node Exporter..."
systemctl daemon-reload
systemctl enable --now node
systemctl status node --no-pager

echo "✅ Node Exporter setup completed."

#-------------------------------------------------------------
# 3. Setup Titan App as a Service
#-------------------------------------------------------------
echo "===== [3/6] Setting up Titan App as a Service ====="

# Update system and install Python3 and venv
sudo apt update
sudo apt install -y python3 python3-venv

# Clone the project repository
mkdir -p /tmp/project
cd /tmp/project
echo "Cloning vprofile-project repository..."
git clone https://github.com/hkhcoder/vprofile-project.git
cd vprofile-project/
git checkout monitoring

# Move titan to /opt and set up virtual environment
mkdir -p /opt/titan
echo "Moving Flask app files to /opt/titan..."
mv titan/*  /opt/titan
cd /opt/titan
echo "Creating Python virtual environment..."
python3 -m venv venv
echo "Activating virtual environment and installing requirements..."
source venv/bin/activate
pip install -r requirments.txt
chmod +x app.py

# Create log directory for Titan app and set permissions
mkdir -p /var/log/titan
chown www-data:www-data /var/log/titan
chmod 755 /var/log/titan

# Create systemd service for Flask app
echo "Creating systemd service for Flask app..."
cat <<EOF > /etc/systemd/system/titan.service
[Unit]
Description=Titan App Service
After=network.target

[Service]
User=www-data
Group=www-data
WorkingDirectory=/opt/titan
Environment="PATH=/opt/titan/venv/bin"
ExecStart=/opt/titan/venv/bin/python3 /opt/titan/app.py
Restart=always

[Install]
WantedBy=multi-user.target
EOF

echo "Enabling and starting Titan app service..."
sudo systemctl daemon-reload
sudo systemctl enable titan
sudo systemctl start titan
sudo systemctl status titan --no-pager

echo "✅ Titan app setup and service started successfully."

#-------------------------------------------------------------
# 4. Load Generation Scripts
#-------------------------------------------------------------
echo "===== [4/6] Setting up load generation scripts ====="
apt install -y stress

echo "Downloading load scripts..."
wget -q -P /usr/local/bin/ https://raw.githubusercontent.com/hkhcoder/vprofile-project/refs/heads/monitoring/load.sh
wget -q -P /usr/local/bin/ https://raw.githubusercontent.com/hkhcoder/vprofile-project/refs/heads/monitoring/generate_multi_logs.sh

chmod +x /usr/local/bin/load.sh /usr/local/bin/generate_multi_logs.sh

echo "Starting load generation in background..."
nohup /usr/local/bin/load.sh > /dev/null 2>&1 &
nohup /usr/local/bin/generate_multi_logs.sh > /dev/null 2>&1 &

echo "✅ Load generation setup completed."

#-------------------------------------------------------------
# 5. Install and Configure Alloy (Metrics & Logs)
#-------------------------------------------------------------
echo "===== [5/6] Installing Grafana Alloy (metrics & log collector) ====="
sudo apt install -y gpg
sudo mkdir -p /etc/apt/keyrings/
wget -q -O - https://apt.grafana.com/gpg.key | gpg --dearmor | sudo tee /etc/apt/keyrings/grafana.gpg > /dev/null
echo "deb [signed-by=/etc/apt/keyrings/grafana.gpg] https://apt.grafana.com stable main" | sudo tee /etc/apt/sources.list.d/grafana.list
sudo apt-get update
sudo apt-get install -y alloy

cat <<EOF > /etc/alloy/config.alloy
// Metrics scraping and remote write to Prometheus

prometheus.remote_write "default" {
  endpoint {
    url = "http://PrometheusIP:9090/api/v1/write"
  }
}

prometheus.scrape "metrics_5000" {
  targets = [{
    __address__ = "localhost:5000",
    __metrics_path__ = "/metrics",
  }]
  forward_to = [prometheus.remote_write.default.receiver]
}

prometheus.scrape "metrics_default" {
  targets = [{
    __address__ = "localhost:8080",  // Adjust port if different; assuming 8080 for /metrics endpoint
    __metrics_path__ = "/metrics",
  }]
  forward_to = [prometheus.remote_write.default.receiver]
}

// Log collection from files and push to Loki

local.file_match "titan_logs" {
  path_targets = [{
    __path__ = "/var/log/titan/*.log",
    job      = "titan",
    hostname = constants.hostname,
  }]
  sync_period = "5s"
}

loki.source.file "log_scrape" {
  targets       = local.file_match.titan_logs.targets
  forward_to    = [loki.write.loki.receiver]
  tail_from_end = true
}

loki.write "loki" {
  endpoint {
    url = "http://LokiIP:3100/loki/api/v1/push"
  }
}
EOF

cat <<EOF > /etc/default/alloy
## Path:
## Description: Grafana Alloy settings
## Type:        string
## Default:     ""
## ServiceRestart: alloy
#
# Command line options for Alloy.
#
# The configuration file holding the Alloy config.
CONFIG_FILE="/etc/alloy/config.alloy"

# User-defined arguments to pass to the run command.
CUSTOM_ARGS="--server.http.listen-addr=0.0.0.0:12345"

# Restart on system upgrade. Defaults to true.
RESTART_ON_UPGRADE=true
EOF

systemctl restart alloy
systemctl enable alloy
sleep 40
systemctl status alloy --no-pager
echo "✅ Alloy setup completed."

#-------------------------------------------------------------
# 7. Configure UFW Firewall
#-------------------------------------------------------------
echo "===== [7/6] Configuring UFW Firewall ====="

# Install ufw if not present
apt install -y ufw

# Allow SSH (port 22), Node Exporter (9100), Loki (3100), and Flask app (80)
echo "Allowing SSH (22), Node Exporter (9100), Loki (3100), and Flask app (80) through firewall..."
ufw allow 22/tcp
ufw allow 9100/tcp
ufw allow 3100/tcp
ufw allow 5000/tcp
ufw allow 12345/tcp


# Enable UFW (force yes)
echo "Enabling UFW..."
echo "y" | ufw enable
ufw status verbose

echo "✅ UFW firewall configured."

#-------------------------------------------------------------
# 6. Final Summary
#-------------------------------------------------------------
echo "============================================================="
echo "🎉  Setup completed successfully!"
echo "-------------------------------------------------------------"
echo " Node Exporter  : Running on port 9100"
echo " Apache Website : Available at http://$(hostname -I | awk '{print $1}')"
echo " Alloy Metrics  : Forwarding to Prometheus at PrometheusIP:9090"
echo " Alloy Logs     : Forwarding to Loki at LokiIP:3100"
echo "============================================================="
