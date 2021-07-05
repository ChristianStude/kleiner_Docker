#!/bin/sh

# APT im nicht interaktiven Modus
export DEBIAN_FRONTEND=noninteractive

# Docker installieren
apt-get -y install apt-transport-https ca-certificates curl \
    gnupg lsb-release
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | 
    sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo \
  "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
apt-get update
apt-get -y install docker-ce docker-ce-cli containerd.io \
  git docker-compose

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

# Chatbot
# Repo klonen und Container starten
mkdir -p /home/git && cd /home/git
git clone https://github.com/ChristianStude/chatbot
cd chatbot && mkdir v3/model

# Container starten
docker-compose up -d

# Traefik
# traefik.yml erstellen
mkdir -p /etc/traefik && cd /etc/traefik
echo "# Docker configuration backend"> traefik.yml
echo "providers:" >> traefik.yml
echo " docker:" >> traefik.yml
echo "  defaultRule: \"Host(\`{{ trimPrefix \`/\` .Name }}.docker.localhost\`)\"" >> traefik.yml
echo "api:" >> traefik.yml
echo " insecure: true" >> traefik.yml

# Traefic starten
docker run -d -p 8080:8080 -p 80:80 \
-v $PWD/traefik.yml:/etc/traefik/traefik.yml \
-v /var/run/docker.sock:/var/run/docker.sock \
traefik:v2.0

# Server starten
docker run -d --name test containous/whoami

# $ curl --header 'Host:test.docker.localhost' 'http://localhost:80/'
curl test.docker.localhost
