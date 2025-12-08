#!/usr/bin/env bash
set -euo pipefail

# This script updates Azure VPN gateway IPs in StrongSwan config and secrets.
# It does not need to know old IPs - it reads them from /etc/ipsec.conf.
# Usage: fixip.sh <new_gw1_ip> <new_gw2_ip>
#
#   new_gw1_ip - new IP for connection "azure-gw1"
#   new_gw2_ip - new IP for connection "azure-gw2"

if [ "$#" -ne 2 ]; then
  echo "Usage: $0 <new_gw1_ip> <new_gw2_ip>"
  exit 1
fi

NEW_GW1="$1"
NEW_GW2="$2"

CONF_FILE="/etc/ipsec.conf"
SECRETS_FILE="/etc/ipsec.secrets"

# Check root permissions
if [ "$EUID" -ne 0 ]; then
  echo "Please run this script as root."
  exit 1
fi

# Check files exist
if [ ! -f "$CONF_FILE" ]; then
  echo "Config file not found: $CONF_FILE"
  exit 1
fi

if [ ! -f "$SECRETS_FILE" ]; then
  echo "Secrets file not found: $SECRETS_FILE"
  exit 1
fi

# Escape IP for sed search (regex) - we only need to escape dots
escape_ip_for_sed_search() {
  echo "$1" | sed 's/\./\\./g'
}

# Update one gateway: find old IP by conn name in ipsec.conf,
# then replace it with new IP in both ipsec.conf and ipsec.secrets.
update_gateway() {
  local CONN_NAME="$1"
  local NEW_IP="$2"

  # Extract the old IP from the right= line in the given conn section
  # We search from "conn <name>" until the next "conn " line.
  local OLD_IP
  OLD_IP="$(
    sed -n "/^conn ${CONN_NAME}\$/,/^conn /{
      /^[[:space:]]*right=/s/.*right=\(.*\)/\1/p
    }" "$CONF_FILE" | head -n 1
  )"

  # Take only the first token in case there are comments after the IP
  OLD_IP="${OLD_IP%% *}"

  if [ -z "${OLD_IP}" ]; then
    echo "Could not find right= line for connection '${CONN_NAME}' in ${CONF_FILE}"
    exit 1
  fi

  if [ "$OLD_IP" = "$NEW_IP" ]; then
    echo "${CONN_NAME}: IP is already ${NEW_IP}, skipping"
    return
  fi

  local OLD_ESC
  OLD_ESC="$(escape_ip_for_sed_search "$OLD_IP")"

  echo "${CONN_NAME}: updating ${OLD_IP} -> ${NEW_IP}"

  # Replace old IP with new IP in both files
  sed -i "s/${OLD_ESC}/${NEW_IP}/g" "$CONF_FILE"
  sed -i "s/${OLD_ESC}/${NEW_IP}/g" "$SECRETS_FILE"
}

# First update azure-gw1, then azure-gw2
update_gateway "azure-gw1" "$NEW_GW1"
update_gateway "azure-gw2" "$NEW_GW2"

echo "Done."
