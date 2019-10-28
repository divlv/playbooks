#!/bin/bash

#
# Erase all firewall rules
iptables -F
iptables -X

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

#
# DOCKER: allow exposing ports, but respect IPTABLES rules:
iptables -A FORWARD -i docker0 -o eth0 -j ACCEPT
iptables -A FORWARD -i eth0 -o docker0 -j ACCEPT
#

# MAIN PART ######################################################################

# Web server traffic
iptables -A INPUT -p tcp -m multiport -m tcp --dports 80,443 -j ACCEPT

# App server traffic from Home/Work
iptables -A INPUT -p tcp -s 159.148.74.220 -m tcp --dport 8080 -j ACCEPT
iptables -A INPUT -p tcp -s 80.233.156.0/22 -m tcp --dport 8080 -j ACCEPT

# Wildfly App server Administration traffic from Home/Work
iptables -A INPUT -p tcp -s 159.148.74.220 -m tcp --dport 9990 -j ACCEPT
iptables -A INPUT -p tcp -s 80.233.156.0/22 -m tcp --dport 9990 -j ACCEPT

# SSH Home (including Ansible hub)
iptables -A INPUT -p tcp -s 159.148.74.220 -m multiport -m tcp --dports 22,22122 -j ACCEPT
iptables -A INPUT -p tcp -s 80.233.156.0/22 -m multiport -m tcp --dports 22,22122 -j ACCEPT

# PostgreSQL
iptables -A INPUT -p tcp -s 159.148.74.220 -m tcp --dport 5432 -j ACCEPT
iptables -A INPUT -p tcp -s 80.233.156.0/22 -m tcp --dport 5432 -j ACCEPT

# Monit
iptables -A INPUT -p tcp -s 159.148.74.220 -m tcp --dport 2812 -j ACCEPT
iptables -A INPUT -p tcp -s 80.233.156.0/22 -m tcp --dport 2812 -j ACCEPT

# Portainer
iptables -A INPUT -p tcp -s 159.148.74.220 -m tcp --dport 19000 -j ACCEPT
iptables -A INPUT -p tcp -s 80.233.156.0/22 -m tcp --dport 19000 -j ACCEPT

##################################################################################

# Allow outgoing connections for previously established incoming connections
iptables -I INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

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
