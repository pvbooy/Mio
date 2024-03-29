#@PvBoy
# 2023/11/15 17:50

#!/bin/bash

# پاک کردن صفحه ترمینال
clear

# اضافه کردن جلوه‌های بصری به پیام‌های سازنده
echo -e "\e[1;32m***********************"
echo -e "***********************"
echo -e "******Made by Boy******"
echo -e "***********************"
echo -e "***********************\e[0m"

# تنظیم ساعت به وقت ایران
export TZ="Asia/Tehran"

# نمایش تاریخ و ساعت ایران
echo -e "\e[1;36m$(date "+%Y/%m/%d|%H:%M:%S")\e[0m"

# بررسی آرگومان خط فرمان برای تعیین نصب یا عدم نصب وارپ
read -p "آیا مایل به نصب وارپ هستید؟ (y/n): " install_warp
if [ $install_warp == "y" ]; then
    # نصب وارپ و مراحل بعدی
    echo -e "\e[1;32mInstalling WireGuard (Warp)..."

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
    echo "Successful wairgard warp..."
else
    echo "Delete Ip6 & Check!!!!!!"
    # اضافه کردن راه حل‌های مربوطه برای رفع ارور
fi

echo -e "WireGuard (Warp) installed successfully.\e[0m"
    # عدم نصب وارپ و اجرای مراحل بعدی
    echo -e "\e[1;31mSkipping WireGuard (Warp) installation.\e[0m"
    # TODO: اضافه کردن دستورات مربوط به مراحل بعدی بدون نصب وارپ
fi
    # TODO: اضافه کردن دستورات مربوط به اضافه کردن فایل‌های مورد نیاز
    echo -e "\e[1;32mAdding required files..."
    mkdir -p /usr/local/share/xray/ && \
    wget -O /usr/local/share/xray/iran.dat https://github.com/bootmortis/iran-hosted-domains/releases/download/202308070029/iran.dat && \
    wget -O /usr/local/share/xray/geoip.dat https://github.com/v2fly/geoip/releases/latest/download/geoip.dat && \
    wget -O /usr/local/share/xray/geosite.dat https://github.com/v2fly/domain-list-community/releases/latest/download/dlc.dat

# نصب وابستگی‌ها
apt install wget unzip -y

# ایجاد دایرکتوری مربوطه
mkdir -p /var/lib/marzban/xray-core

# دانلود و استخراج فایل Xray
wget -O /var/lib/marzban/xray-core/Xray-linux-64.zip https://github.com/XTLS/Xray-core/releases/download/v1.8.1/Xray-linux-64.zip
unzip /var/lib/marzban/xray-core/Xray-linux-64.zip -d /var/lib/marzban/xray-core

# حذف فایل فشرده دانلود شده
rm /var/lib/marzban/xray-core/Xray-linux-64.zip

#نصب مرزبان نود
curl -fsSL https://get.docker.com | sh
git clone https://github.com/Gozargah/Marzban-node
(cd ~/Marzban-node && docker compose up -d)
rm Marzban-node/docker-compose.yml ;
wget -O Marzban-node/docker-compose.yml https://host-upload-data-boy.site/node/docker-compose.yml ;
wget -O /var/lib/marzban-node/ssl_client_cert.pem https://host-upload-data-boy.site/node/ssl_client_cert.pem
(cd ~/Marzban-node && docker compose down && docker compose up --remove-orphans -d)
