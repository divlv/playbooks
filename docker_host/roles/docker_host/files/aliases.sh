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
echo "alias ports='netstat -an | grep LISTEN'" >> ~/.bash_aliases && source ~/.bash_aliases

#Docker related aliases: Stop all containers
echo "alias dstop='docker stop $(docker ps -aq)'" >> ~/.bash_aliases && source ~/.bash_aliases

