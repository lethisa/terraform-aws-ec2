#!/usr/bin/env bash
set -euo pipefail

echo "Updating packages..."
sudo apt-get update -y

echo "Installing dependencies..."
sudo apt-get install -y \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

echo "Installing Docker..."
sudo apt-get install -y docker.io

echo "Enabling Docker service..."
sudo systemctl enable docker
sudo systemctl start docker

echo "Configuring application service..."

sudo tee /etc/systemd/system/app.service > /dev/null <<EOF
[Unit]
Description=TIA Web Application Container
Requires=docker.service
After=docker.service network-online.target

[Service]
Restart=always
RestartSec=5
TimeoutStartSec=0

Environment=CONSUL_ALLOW_PRIVILEGED_PORTS=true

ExecStartPre=-/usr/bin/docker rm -f ${CONTAINER_NAME}
ExecStartPre=/usr/bin/docker pull ${CONTAINER_IMAGE}

ExecStart=/usr/bin/docker run \
  --name ${CONTAINER_NAME} \
  -e NAME=\${NAME} \
  -e BG_COLOR=\${BG_COLOR} \
  -p ${HOST_PORT}:${CONTAINER_PORT} \
  --log-driver=journald \
  ${CONTAINER_IMAGE}

ExecStop=/usr/bin/docker stop ${CONTAINER_NAME}
ExecStopPost=-/usr/bin/docker rm -f ${CONTAINER_NAME}

[Install]
WantedBy=multi-user.target
EOF

echo "Reloading systemd..."
sudo systemctl daemon-reload

echo "Starting application service..."
sudo systemctl enable app.service
sudo systemctl start app.service

echo "Startup script completed successfully."