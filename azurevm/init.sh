#!/bin/bash
#
#
# Init commands for AzureVM or K3s "small" server...
#

echo "alias getsize='du -a -h --max-depth=1'" >> /root/.bash_aliases
echo "alias ffind='find / -name '" >> /root/.bash_aliases
echo "alias ports='netstat -anltpu | grep -E udp\|LISTEN'" >> /root/.bash_aliases
echo "alias portsa='netstat -anltp'" >> /root/.bash_aliases
echo "alias dstop='docker stop '" >> /root/.bash_aliases
echo "alias iptl='iptables -nv -L'" >> /root/.bash_aliases
echo "alias checkport='nc -w5 -z -v '" >> /root/.bash_aliases
echo "alias myip='dig +short myip.opendns.com @resolver1.opendns.com'" >> /root/.bash_aliases

apt update

apt install -y apt-transport-https netcat
apt-add-repository -y universe

apt update

apt install -y ncdu
#