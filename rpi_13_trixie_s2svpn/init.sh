#!/bin/bash
#
#
# Init commands for "Raspbian GNU/Linux 13 (trixie) Lite" to be used as Azure S2S On-Prem VPN Gateway
#

sudo apt update

sudo apt install -y strongswan strongswan-pki strongswan-starter iproute2 netcat mc ncdu tcpdump
