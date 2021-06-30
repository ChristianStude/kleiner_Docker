#!/bin/sh

# APT im nicht interaktiven Modus
export DEBIAN_FRONTEND=noninteractive

# System aktualisieren
apt-get update && apt-get -y dist-upgrade && apt-get --purge -y autoremove
