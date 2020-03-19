#!/bin/bash
#
# Adding liux command aliases
#
#
#Adding directory size command alias
echo "alias getsize='du -a -h --max-depth=1'" >> ~/.bash_aliases && source ~/.bash_aliases

#Adding file find command alias
echo "alias ffind='find / -name '" >> ~/.bash_aliases && source ~/.bash_aliases

#Adding open ports display command alias
echo "alias ports='netstat -anltp | grep LISTEN'" >> ~/.bash_aliases && source ~/.bash_aliases

#Adding all ports in use display command alias
echo "alias portsa='netstat -anltp'" >> ~/.bash_aliases && source ~/.bash_aliases

#Docker related aliases: Stop all containers
echo "alias dstop='docker stop $(docker ps -aq)'" >> ~/.bash_aliases && source ~/.bash_aliases

#IP Tables: detailed report
echo "alias iptl='iptables -nv -L'" >> ~/.bash_aliases && source ~/.bash_aliases

#Check if particular port is opened: checkport ya.ru 443
echo "alias checkport='nc -w5 -z -v '" >> ~/.bash_aliases && source ~/.bash_aliases
