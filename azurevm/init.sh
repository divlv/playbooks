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

apt install -y apt-transport-https netcat mc
apt-add-repository -y universe

apt update

apt install -y ncdu
#

# --- MC skins + TrueColor + default 'norton' ----------
# Assumes MC is already installed.

# 1) Ensure skin directories exist
mkdir -p /root/.local/share/mc/skins
mkdir -p /home/ubuntu/.local/share/mc/skins

# 2) Copy available skins from ./mcskins (soft-fail if missing)
cp -f ./mcskins/far-manager.ini      /root/.local/share/mc/skins/far-manager.ini      || true
cp -f ./mcskins/norton-commander.ini /root/.local/share/mc/skins/norton-commander.ini || true
cp -f ./mcskins/volkov-commander.ini /root/.local/share/mc/skins/volkov-commander.ini || true

cp -f ./mcskins/far-manager.ini      /home/ubuntu/.local/share/mc/skins/far-manager.ini      || true
cp -f ./mcskins/norton-commander.ini /home/ubuntu/.local/share/mc/skins/norton-commander.ini || true
cp -f ./mcskins/volkov-commander.ini /home/ubuntu/.local/share/mc/skins/volkov-commander.ini || true

# 3) Fix ownership for ubuntu's files
chown -R ubuntu:ubuntu /home/ubuntu/.local || true

# 4) Ensure COLORTERM=truecolor (append with a leading blank line)
#    (No duplicate checks by design.)
touch /root/.bashrc
printf '\nexport COLORTERM=truecolor\n' >> /root/.bashrc

touch /home/ubuntu/.bashrc
printf '\nexport COLORTERM=truecolor\n' >> /home/ubuntu/.bashrc
chown ubuntu:ubuntu /home/ubuntu/.bashrc || true

# 5) Set default MC skin to 'norton-commander' for both users without overwriting existing configs
#    We simply append a new [Midnight-Commander] section at the end; MC reads the last value.
mkdir -p /root/.config/mc
touch /root/.config/mc/ini
printf '\n[Midnight-Commander]\nskin=norton-commander\n' >> /root/.config/mc/ini

mkdir -p /home/ubuntu/.config/mc
touch /home/ubuntu/.config/mc/ini
printf '\n[Midnight-Commander]\nskin=norton-commander\n' >> /home/ubuntu/.config/mc/ini
chown -R ubuntu:ubuntu /home/ubuntu/.config/mc || true
