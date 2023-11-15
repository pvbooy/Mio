#!/bin/bash

# اضافه کردن repository ها
sudo add-apt-repository main
sudo add-apt-repository universe
sudo add-apt-repository restricted
sudo add-apt-repository multiverse -y

# دانلود و نصب wgcf
wget https://github.com/ViRb3/wgcf/releases/download/v2.2.18/wgcf_2.2.18_linux_amd64
mv wgcf_2.2.18_linux_amd64 /usr/bin/wgcf
chmod +x /usr/bin/wgcf
wgcf register --accept-tos
wgcf generate

# نصب WireGuard و تنظیمات آن
sudo apt install wireguard-dkms wireguard-tools resolvconf -y
mv wgcf-profile.conf warp.conf
sudo mv warp.conf /etc/wireguard/
sudo sed -i '7i\Table = off' /etc/wireguard/warp.conf
sudo systemctl enable --now wg-quick@warp
