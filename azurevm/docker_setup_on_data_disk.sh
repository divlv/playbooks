#!/bin/bash

# Azure VM: install Docker, point its data-root at /data/docker (disk_setup.sh must have run first)

# Exit immediately on error, treat unset variables as errors, and make pipelines fail if any element fails:
set -euo pipefail

echo "=== STEP 1) Install docker.io and docker-compose ==="
apt-get update
DEBIAN_FRONTEND=noninteractive apt-get install -y docker.io docker-compose

echo
echo "=== STEP 2) Configure Docker data-root ==="
# Create the directory on your HDD
mkdir -p /data/docker
chown root:root /data/docker
chmod 711 /data/docker

# Write daemon.json pointing Docker at /data/docker
cat > /etc/docker/daemon.json <<EOF
{
  "data-root": "/data/docker"
}
EOF

echo
echo "=== STEP 3) Remove any systemd override ==="
OVERRIDE_DIR=/etc/systemd/system/docker.service.d
if [[ -d "$OVERRIDE_DIR" ]]; then
  echo "Found $OVERRIDE_DIR, removing to let Docker use daemon.json"
  rm -f "$OVERRIDE_DIR/override.conf"
  rmdir "$OVERRIDE_DIR" || true
fi

echo
echo "=== STEP 4) Reload systemd & restart Docker ==="
systemctl daemon-reload
systemctl enable docker
if ! systemctl restart docker; then
  echo "ERROR: Docker failed to start. Dumping last 20 lines of journal:" >&2
  journalctl -u docker.service -n20 --no-pager >&2
  exit 1
fi

echo "✔ Docker is running."
echo "   Docker Root Dir now:"
docker info | grep "Docker Root Dir"
echo


echo
echo "All done!"
