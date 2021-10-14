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

# --------------Didn't worked last time. Left for reference...-----------
#iptables -N DOCKER
#iptables -N DOCKER-ISOLATION-STAGE-1
#iptables -N DOCKER-ISOLATION-STAGE-2
#iptables -N DOCKER-USER

#iptables -A FORWARD -j DOCKER-USER
#iptables -A FORWARD -j DOCKER-ISOLATION-STAGE-1
#iptables -A FORWARD -o docker0 -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
#iptables -A FORWARD -o docker0 -j DOCKER
#iptables -A FORWARD -i docker0 ! -o docker0 -j ACCEPT
#iptables -A FORWARD -i docker0 -o docker0 -j ACCEPT

#iptables -A DOCKER-ISOLATION-STAGE-1 -i docker0 ! -o docker0 -j DOCKER-ISOLATION-STAGE-2
#iptables -A DOCKER-ISOLATION-STAGE-1 -j RETURN
#iptables -A DOCKER-ISOLATION-STAGE-2 -o docker0 -j DROP
#iptables -A DOCKER-ISOLATION-STAGE-2 -j RETURN
#iptables -A DOCKER-USER -j RETURN
# ----------------------------------------------------------------------

#
# This opens Container's forwarding on new (U18) systems,
# and works like simply iptables forwarding between 2 interfaces
#
# MAIN PART ######################################################################

ipset destroy trustedips
ipset -N trustedips iphash
#
ipset -A trustedips 185.81.51.167
#
# Sometimes it needs to make requests to/from the same machine via Domain Name.
# That's why own external IP should be opened:
#IP_OF_CURRENT_MACHINE_IF_NEEDED
#
###
ipset destroy trustednets
ipset -N trustednets nethash
#
ipset -A trustednets 80.233.156.0/22
ipset -A trustednets 194.8.32.0/21
ipset -A trustednets 194.8.40.0/22
#
# FIXME: Temporary! To be removed!!! (TELE2 mob.)
ipset -A trustednets 77.219.0.0/19
#
#
# ...PG for on-host Docker containers (private IP range)
ipset -A trustednets 172.16.0.0/12
# GitLab CI/CD
ipset -A trustednets 8.34.208.0/20
ipset -A trustednets 8.35.192.0/21
ipset -A trustednets 8.35.200.0/23
ipset -A trustednets 23.236.48.0/20
ipset -A trustednets 23.251.128.0/19
ipset -A trustednets 34.64.0.0/11
ipset -A trustednets 34.96.0.0/14
ipset -A trustednets 34.100.0.0/16
ipset -A trustednets 34.102.0.0/15
ipset -A trustednets 34.104.0.0/14
ipset -A trustednets 34.124.0.0/18
ipset -A trustednets 34.124.64.0/20
ipset -A trustednets 34.124.80.0/23
ipset -A trustednets 34.124.84.0/22
ipset -A trustednets 34.124.88.0/23
ipset -A trustednets 34.124.92.0/22
ipset -A trustednets 34.125.0.0/16
ipset -A trustednets 35.184.0.0/14
ipset -A trustednets 35.188.0.0/15
ipset -A trustednets 35.190.0.0/17
ipset -A trustednets 35.190.128.0/18
ipset -A trustednets 35.190.192.0/19
ipset -A trustednets 35.190.224.0/20
ipset -A trustednets 35.190.240.0/22
ipset -A trustednets 35.192.0.0/14
ipset -A trustednets 35.196.0.0/15
ipset -A trustednets 35.198.0.0/16
ipset -A trustednets 35.199.0.0/17
ipset -A trustednets 35.199.128.0/18
ipset -A trustednets 35.200.0.0/13
ipset -A trustednets 35.208.0.0/13
ipset -A trustednets 35.216.0.0/15
ipset -A trustednets 35.219.192.0/24
ipset -A trustednets 35.220.0.0/14
ipset -A trustednets 35.224.0.0/13
ipset -A trustednets 35.232.0.0/15
ipset -A trustednets 35.234.0.0/16
ipset -A trustednets 35.235.0.0/17
ipset -A trustednets 35.235.192.0/20
ipset -A trustednets 35.235.216.0/21
ipset -A trustednets 35.235.224.0/20
ipset -A trustednets 35.236.0.0/14
ipset -A trustednets 35.240.0.0/13
ipset -A trustednets 104.154.0.0/15
ipset -A trustednets 104.196.0.0/14
ipset -A trustednets 107.167.160.0/19
ipset -A trustednets 107.178.192.0/18
ipset -A trustednets 108.59.80.0/20
ipset -A trustednets 108.170.192.0/20
ipset -A trustednets 108.170.208.0/21
ipset -A trustednets 108.170.216.0/22
ipset -A trustednets 108.170.220.0/23
ipset -A trustednets 108.170.222.0/24
ipset -A trustednets 130.211.4.0/22
ipset -A trustednets 130.211.8.0/21
ipset -A trustednets 130.211.16.0/20
ipset -A trustednets 130.211.32.0/19
#####


# Web server traffic
iptables -A INPUT -p tcp -m multiport -m tcp --dports 80,443,1080 -j ACCEPT

# [temporary] GrayLog Server (Security through obscurity. Original port - 12201)
iptables -A INPUT -p tcp -m multiport -m tcp --dports 12250,12251 -j ACCEPT
iptables -A INPUT -p udp -m multiport -m udp --dports 12250,12251 -j ACCEPT

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
