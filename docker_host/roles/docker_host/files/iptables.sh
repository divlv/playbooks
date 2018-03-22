#!/bin/bash

# Erase all firewall rules
iptables -F

# Block null packets.
iptables -A INPUT -p tcp --tcp-flags ALL NONE -j DROP

# Reject is a syn-flood attack.
iptables -A INPUT -p tcp ! --syn -m state --state NEW -j DROP

# Common attack: XMAS packets, also a recon packet.
iptables -A INPUT -p tcp --tcp-flags ALL ALL -j DROP

# Open up ports for selected services #############################
# localhost interface
iptables -A INPUT -i lo -j ACCEPT

#allow web server traffic
iptables -A INPUT -p tcp -m tcp --dport 80 -j ACCEPT
iptables -A INPUT -p tcp -m tcp --dport 443 -j ACCEPT

#allow App server traffic from Home/Work
iptables -A INPUT -p tcp -s 159.148.74.220 -m tcp --dport 8080 -j ACCEPT
iptables -A INPUT -p tcp -s 80.233.156.0/22 -m tcp --dport 8080 -j ACCEPT

#allow App server Administration traffic from Home/Work
iptables -A INPUT -p tcp -s 159.148.74.220 -m tcp --dport 9990 -j ACCEPT
iptables -A INPUT -p tcp -s 80.233.156.0/22 -m tcp --dport 9990 -j ACCEPT

# SSH Home
iptables -A INPUT -p tcp -s 159.148.74.220 -m tcp --dport 22122 -j ACCEPT
iptables -A INPUT -p tcp -s 159.148.74.220 -m tcp --dport 22 -j ACCEPT
iptables -A INPUT -p tcp -s 80.233.156.0/22 -m tcp --dport 22122 -j ACCEPT
iptables -A INPUT -p tcp -s 80.233.156.0/22 -m tcp --dport 22 -j ACCEPT

# SSH Ansible host
iptables -A INPUT -p tcp -s 185.185.68.178 -m tcp --dport 22 -j ACCEPT

# PostgreSQL
iptables -A INPUT -p tcp -s 159.148.74.220 -m tcp --dport 5432 -j ACCEPT
iptables -A INPUT -p tcp -s 80.233.156.0/22 -m tcp --dport 5432 -j ACCEPT

# Monit
iptables -A INPUT -p tcp -s 159.148.74.220 -m tcp --dport 2812 -j ACCEPT
iptables -A INPUT -p tcp -s 80.233.156.0/22 -m tcp --dport 2812 -j ACCEPT


# Allow o use outgoing connections
iptables -I INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

# Block everything else, and allow all outgoing connections.
iptables -P OUTPUT ACCEPT
iptables -P INPUT DROP

# List all rules
iptables -L -n

# Save all rules
iptables-save > /etc/network/iptables.rules
#netfilter-persistent save

# Restart IPtables
# REBOOT needed
#service iptables restart
#netfilter-persistent reload

#eof
