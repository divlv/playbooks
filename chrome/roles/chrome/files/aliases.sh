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

#Docker related alias: Docker stop all containers
echo "alias dstop='docker kill $(docker ps -q)'" >> ~/.bash_aliases && source ~/.bash_aliases

#Docker related alias: Docker clean containers
echo "alias dclean='docker rm $(docker ps -a -q)'" >> ~/.bash_aliases && source ~/.bash_aliases

#Docker related alias: Docker clean images
echo "alias dwipe='docker rmi $(docker images -q)'" >> ~/.bash_aliases && source ~/.bash_aliases

#Docker related alias: Docker remove all data (slow)
echo "alias drefresh='docker system prune --all -f'" >> ~/.bash_aliases && source ~/.bash_aliases
