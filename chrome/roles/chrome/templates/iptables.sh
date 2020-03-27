#!/bin/bash

# Erase all firewall rules
iptables -F

# Block null packets.
iptables -A INPUT -p tcp --tcp-flags ALL NONE -j DROP

# Reject is a syn-flood attack.
iptables -A INPUT -p tcp ! --syn -m state --state NEW -j DROP

# Common attack: XMAS packets, also a recon packet.
iptables -A INPUT -p tcp --tcp-flags ALL ALL -j DROP

# localhost interface
iptables -A INPUT -i lo -j ACCEPT

#allow web server traffic
iptables -A INPUT -p tcp -s {{ base_ip }} -m tcp --dport 80 -j ACCEPT
iptables -A INPUT -p tcp -s {{ base_ip }} -m tcp --dport 80 -j ACCEPT
iptables -A INPUT -p tcp -s {{ client_ip }} -m tcp --dport 443 -j ACCEPT
iptables -A INPUT -p tcp -s {{ client_ip }} -m tcp --dport 443 -j ACCEPT


#Allow Renderer traffic only from known hosts
iptables -A INPUT -p tcp -s {{ base_ip }} -m tcp --dport {{ rendertron_port }} -j ACCEPT
iptables -A INPUT -p tcp -s {{ client_ip }} -m tcp --dport {{ rendertron_port }} -j ACCEPT


# SSH Home
iptables -A INPUT -p tcp -s {{ base_ip }} -m tcp --dport 22 -j ACCEPT

# Allow use outgoing connections
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
