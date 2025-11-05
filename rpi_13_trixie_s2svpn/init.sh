#!/bin/bash
#
#
# Init commands for "Raspbian GNU/Linux 13 (trixie) Lite" to be used as Azure S2S On-Prem VPN Gateway
#

sudo apt update

sudo apt install -y strongswan strongswan-pki strongswan-starter iproute2 netcat-openbsd dnsutils mc ncdu tcpdump dnsmasq

# Prepare log directory for dnsmasq
mkdir -p /opt/log

# Create IP-forwarding rule
sudo tee /etc/sysctl.d/99-ipforward.conf >/dev/null <<'EOF'
# Enable IPv4 forwarding permanently
net.ipv4.ip_forward=1
# Optional: enable IPv6 forwarding too
#net.ipv6.conf.all.forwarding=1

# Optional: Disable ICMP redirects (security)
#net.ipv4.conf.all.accept_redirects=0
#net.ipv4.conf.all.send_redirects=0


EOF

# It's nice to reboot the system after making these changes