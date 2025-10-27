#!/bin/bash
#
#
# Updating IPsec/StrongSwan configuration with IP real addresses
#

LOCAL_VNET_DEVICE_EXTERNAL_IP="11.22.33.44"
LOCAL_INTERNAL_SUBNET="192.168.1.0/24"

AZURE_VPN_VNET="10.82.0.0/22"
AZURE_RESOURCES_VNET_1="10.82.4.0/22"

AZURE_VPN_GATEWAY_IP_1="20.30.40.50"
AZURE_VPN_GATEWAY_IP_2="20.30.40.51"

# Find all ipsec.* files recursively and replace placeholders
find . -type f -name "ipsec.*" -exec sed -i "s|#LOCAL_VNET_DEVICE_EXTERNAL_IP#|${LOCAL_VNET_DEVICE_EXTERNAL_IP}|g" {} \;
find . -type f -name "ipsec.*" -exec sed -i "s|#LOCAL_INTERNAL_SUBNET#|${LOCAL_INTERNAL_SUBNET}|g" {} \;
find . -type f -name "ipsec.*" -exec sed -i "s|#AZURE_VPN_VNET#|${AZURE_VPN_VNET}|g" {} \;
find . -type f -name "ipsec.*" -exec sed -i "s|#AZURE_RESOURCES_VNET_1#|${AZURE_RESOURCES_VNET_1}|g" {} \;
find . -type f -name "ipsec.*" -exec sed -i "s|#AZURE_VPN_GATEWAY_IP_1#|${AZURE_VPN_GATEWAY_IP_1}|g" {} \;
find . -type f -name "ipsec.*" -exec sed -i "s|#AZURE_VPN_GATEWAY_IP_2#|${AZURE_VPN_GATEWAY_IP_2}|g" {} \;
