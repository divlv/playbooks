#!/bin/bash
#
#
# JITSI - System initialization script
#

echo "alias getsize='du -a -h --max-depth=1'" >> /root/.bash_aliases
echo "alias ffind='find / -name '" >> /root/.bash_aliases
echo "alias ports='netstat -anltpu | grep -E udp\|LISTEN'" >> /root/.bash_aliases
echo "alias portsa='netstat -anltp'" >> /root/.bash_aliases
echo "alias dstop='docker stop '" >> /root/.bash_aliases
echo "alias iptl='iptables -nv -L'" >> /root/.bash_aliases
echo "alias checkport='nc -w5 -z -v '" >> /root/.bash_aliases
echo "alias myip='dig +short myip.opendns.com @resolver1.opendns.com'" >> /root/.bash_aliases

echo "alias getsize='du -a -h --max-depth=1'" >> /home/administrator/.bash_aliases
echo "alias ffind='find / -name '" >> /home/administrator/.bash_aliases
echo "alias ports='netstat -anltpu | grep -E udp\|LISTEN'" >> /home/administrator/.bash_aliases
echo "alias portsa='netstat -anltp'" >> /home/administrator/.bash_aliases
echo "alias dstop='docker stop '" >> /home/administrator/.bash_aliases
echo "alias iptl='iptables -nv -L'" >> /home/administrator/.bash_aliases
echo "alias checkport='nc -w5 -z -v '" >> /home/administrator/.bash_aliases
echo "alias myip='dig +short myip.opendns.com @resolver1.opendns.com'" >> /home/administrator/.bash_aliases

apt update

apt install -y apt-transport-https
apt-add-repository -y universe

apt update

apt install -y net-tools
apt install -y curl
apt install -y mc
apt install -y ncdu

apt install -y openssh-server
systemctl enable ssh
systemctl start ssh


hostnamectl set-hostname ???.v1.lv
