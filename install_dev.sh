#@PvBoy
# 2023/11/15 17:50

#!/bin/bash

# پاک کردن صفحه ترمینال
clear

# اضافه کردن جلوه‌های بصری به پیام‌های سازنده
echo -e "\e[1;32m***********************"
echo -e "***********************"
echo -e "**********Boy**********"
echo -e "***********************"
echo -e "***********************\e[0m"

# تنظیم ساعت به وقت ایران
export TZ="Asia/Tehran"

# نمایش تاریخ و ساعت ایران
echo -e "\e[1;36m$(date "+%Y/%m/%d|%H:%M:%S")\e[0m"

# بررسی آرگومان خط فرمان برای تعیین نصب یا عدم نصب وارپ
read -p "Should Warp be installed? (y/n): " install_warp
install_warp=$(echo "$install_warp" | tr '[:upper:]' '[:lower:]')
if [ "$install_warp" == "y" ]; then
    # نصب وارپ و مراحل بعدی
    echo -e "\e[1;32mInstalling WireGuard (Warp)..."

    # اپدیت
    sudo apt update -y

    # رفع خالی شدن nameserver
    rm /etc/resolv.conf && \
    sudo touch /etc/resolv.conf && \
    echo -e "nameserver 1.1.1.1\nnameserver 1.0.0.1\nnameserver 127.0.0.53" | sudo tee -a /etc/resolv.conf && \


    # افزودن مخازن APT
    sudo add-apt-repository main -y
    sudo add-apt-repository universe -y
    sudo add-apt-repository restricted -y
    sudo add-apt-repository multiverse -y

    # نصب ابزارهای WireGuard و resolvconf
    sudo apt install wireguard-dkms wireguard-tools resolvconf -y

    # دانلود و نصب wgcf
    wget https://github.com/ViRb3/wgcf/releases/download/v2.2.18/wgcf_2.2.18_linux_amd64
    mv wgcf_2.2.18_linux_amd64 /usr/bin/wgcf
    chmod +x /usr/bin/wgcf

    # ثبت و تولید پروفایل
    wgcf register --accept-tos
    wgcf generate

    # انتقال فایل پروفایل به مسیر مورد نظر
    mv wgcf-profile.conf warp.conf
    sudo mv warp.conf /etc/wireguard/

    # اعمال تغییرات در فایل تنظیمات WireGuard
    sudo sed -i '7i\Table = off' /etc/wireguard/warp.conf

# فعال‌سازی سرویس WireGuard
sudo systemctl enable --now wg-quick@warp

if systemctl is-active --quiet wg-quick@warp; then
    echo -e "\e[32m+++Successful wairgard warp...\e[0m"
else
    echo -e "\e[31mEror - Warp service failed to run!\e[0m"
    echo -e "://////"
    systemctl status wg-quick@warp
    exit 1
fi
    # TODO: اضافه کردن دستورات مربوط به اضافه کردن فایل‌های مورد نیاز
    echo -e "\e[1;31m+Adding required files....\e[0m"
    mkdir -p /usr/local/share/xray/ && \
    wget -O /usr/local/share/xray/iran.dat https://github.com/bootmortis/iran-hosted-domains/releases/download/202308070029/iran.dat && \
    wget -O /usr/local/share/xray/geoip.dat https://github.com/v2fly/geoip/releases/latest/download/geoip.dat && \
    wget -O /usr/local/share/xray/geosite.dat https://github.com/v2fly/domain-list-community/releases/latest/download/dlc.dat

# نصب وابستگی‌ها
echo -e "\e[1;31m*Doing the work of core version (1.8.1)\e[0m"
apt install wget unzip -y

# ایجاد دایرکتوری مربوطه
mkdir -p /var/lib/marzban/xray-core

# دانلود و استخراج فایل Xray
wget -O /var/lib/marzban/xray-core/Xray-linux-64.zip https://github.com/XTLS/Xray-core/releases/download/v1.8.1/Xray-linux-64.zip
unzip /var/lib/marzban/xray-core/Xray-linux-64.zip -d /var/lib/marzban/xray-core

# حذف فایل فشرده دانلود شده
rm /var/lib/marzban/xray-core/Xray-linux-64.zip

#نصب مرزبان نود
echo -e "\e[1;31m$Install marzban node + Docker/\e[0m"
curl -fsSL https://get.docker.com | sh
git clone https://github.com/Gozargah/Marzban-node
(cd ~/Marzban-node && docker compose up -d)
rm Marzban-node/docker-compose.yml ;
wget -O Marzban-node/docker-compose.yml https://host-upload-data-boy.site/node/docker-compose.yml 
(cd ~/Marzban-node && docker compose down && docker compose up --remove-orphans -d)
wget -O /var/lib/marzban-node/ssl_client_cert.pem https://host-upload-data-boy.site/node/ssl_client_cert.pem

# تموم
echo -e "\e[94mFinish (⁠✯⁠ᴗ⁠✯⁠)\e[0m"
