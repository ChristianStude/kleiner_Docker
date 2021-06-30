#!/bin/sh

# APT im nicht interaktiven Modus
export DEBIAN_FRONTEND=noninteractive

# System aktualisieren
apt-get update && apt-get -y dist-upgrade && apt-get --purge -y autoremove

# Docker installieren
apt-get update
apt-get -y install apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"
apt-get update
apt-cache policy docker-ce
apt-get -y install docker-ce

systemctl enable --now docker
adduser vagrant docker

# Defaultroute setzen
ip route replace default via 192.168.100.2
ip route delete default via 10.0.2.2

# Konfiguration der Namensauflösung
systemctl disable --now systemd-resolved
rm /etc/resolv.conf
echo "nameserver 192.168.100.2" > /etc/resolv.conf
echo "search kurs.iad" >> /etc/resolv.conf
