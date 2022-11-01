#!/bin/bash
#
#
#
# ( https://jitsi.github.io/handbook/docs/devops-guide/devops-guide-quickstart/ )
#
# JITSI - Packages add
#

echo deb http://packages.prosody.im/debian $(lsb_release -sc) main | sudo tee -a /etc/apt/sources.list

wget https://prosody.im/files/prosody-debian-packages.key -O- | sudo apt-key add -

apt install -y lua5.2

curl https://download.jitsi.org/jitsi-key.gpg.key | sudo sh -c 'gpg --dearmor > /usr/share/keyrings/jitsi-keyring.gpg'

echo 'deb [signed-by=/usr/share/keyrings/jitsi-keyring.gpg] https://download.jitsi.org stable/' | sudo tee /etc/apt/sources.list.d/jitsi-stable.list > /dev/null

apt update

apt install -y jitsi-meet

# Then better reboot the system and add LetsEncrypt certificate:
# sudo /usr/share/jitsi-meet/scripts/install-letsencrypt-cert.sh
# And reboot again

#