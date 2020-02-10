#!/bin/bash

#
# Allows ALL incoming traffic. Use for debug purposes only!
#
# Flush all rules:
iptables -F
iptables -X
iptables -t nat -F
iptables -t nat -X
iptables -t mangle -F
iptables -t mangle -X
iptables -P INPUT ACCEPT
iptables -P FORWARD ACCEPT
iptables -P OUTPUT ACCEPT
#
# Allow ALL incoming traffic:
iptables -I INPUT -j ACCEPT
#
