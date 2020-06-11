#!/bin/bash

#
# Erase all firewall rules
iptables -F
iptables -X
# Erase NAT rules as well
iptables -t nat -F

#
# Default policy: block all incoming
iptables -P INPUT DROP
iptables -P FORWARD DROP
# ...but allow outgoing
iptables -P OUTPUT ACCEPT

#
# Allow unlimited traffic on loopback (localhost)
iptables -A INPUT -i lo -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT

# DOCKER PART #####################################################################
#
# IP forwarding should be enabled:: sysctl -w net.ipv4.ip_forward=1
#
# DOCKER: allow exposing ports, but respect IPTABLES rules:
iptables -A FORWARD -i docker0 -o eth0 -j ACCEPT
iptables -A FORWARD -i eth0 -o docker0 -m state --state ESTABLISHED,RELATED -j ACCEPT
#
# Wildcard rule for Docker/User bridge networks, e.g. "br-f985e578d3a0"
iptables -A FORWARD -i br-+ -o eth0 -j ACCEPT
iptables -A FORWARD -i eth0 -o br-+ -m state --state ESTABLISHED,RELATED -j ACCEPT
#
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
#
# This opens Container's forwarding on new (U18) systems,
# and works like simply iptables forwarding between 2 interfaces
#
# MAIN PART ######################################################################

ipset destroy trustedips
ipset -N trustedips iphash
#
ipset -A trustedips 185.81.51.167
###
ipset destroy trustednets
ipset -N trustednets nethash
#
ipset -A trustednets 80.233.156.0/22
ipset -A trustednets 194.8.32.0/21
ipset -A trustednets 194.8.40.0/22
# ...PG for on-host Docker containers (private IP range)
ipset -A trustednets 172.16.0.0/12


# Web server traffic
iptables -A INPUT -p tcp -m multiport -m tcp --dports 80,443 -j ACCEPT

# Trusted
iptables -A INPUT -p tcp -m multiport -m tcp -m set --match-set trustedips src --dports 22,2812,19000,18000,8080,9000,9090,9990,5432,15432,9323,6379,9273 -j ACCEPT
iptables -A INPUT -p tcp -m multiport -m tcp -m set --match-set trustednets src --dports 22,2812,19000,18000,8080,9000,9090,9990,5432,15432,9323,6379,9273 -j ACCEPT

##################################################################################

# Allow outgoing connections for previously established incoming connections
iptables -I INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

# LOGGING: Log incoming blocked packets to /var/log/syslog  (e.g. --limit 20/min)
# Uncomment, if needed
#
#iptables -N LOGGING
#iptables -A INPUT -j LOGGING
#iptables -A LOGGING -m limit --limit 2/min -j LOG --log-prefix "IPTables-Dropped: " --log-level 4
#iptables -A LOGGING -j DROP


# List all rules and interfaces
iptables -nv -L

# Save all rules
iptables-save > /etc/network/iptables.rules
#netfilter-persistent save

# Restart IPtables
# REBOOT needed
#service iptables restart
#netfilter-persistent reload

#eof
