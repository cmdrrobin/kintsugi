#!/usr/bin/env bash

set -e

echo "Install pipewire-zeroconf package..."
sudo pacman -S pipewire-zeroconf

echo "Configure local firewall to allow Airplay connections..."
sudo ufw allow 6001/udp comment "Stream to Airplay"
sudo ufw allow 6002/udp comment "Stream to Airplay"
