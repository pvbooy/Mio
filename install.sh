#Boy

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
    sudo add-apt-repository main
    sudo add-apt-repository universe
    sudo add-apt-repository restricted
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

# جلوه چرخشی و اجرای دستورات مراحل بعدی
spinner="/|\\-"
while true; do
    for i in $(seq 0 3); do
        echo -ne "\e[1D${spinner:$i:1}"
        sleep 0.1
    done
    # TODO: اضافه کردن دستورات مربوط به اضافه کردن فایل‌های مورد نیاز
    echo -e "\e[1;32mAdding required files..."
    mkdir -p /usr/local/share/xray/ && \
    wget -O /usr/local/share/xray/iran.dat https://github.com/bootmortis/iran-hosted-domains/releases/download/202308070029/iran.dat && \
    wget -O /usr/local/share/xray/geoip.dat https://github.com/v2fly/geoip/releases/latest/download/geoip.dat && \
    wget -O /usr/local/share/xray/geosite.dat https://github.com/v2fly/domain-list-community/releases/latest/download/dlc.dat

    # اضافه کردن دستورات مربوط به نصب هسته و ادیت هسته
    echo -e "\e[1;32mInstalling and configuring kernel..."
    sudo apt install wget unzip -y
    sudo mkdir -p /var/lib/marzban/xray-core
    sudo wget -O /var/lib/marzban/xray-core/Xray-linux-64.zip https://github.com/XTLS/Xray-core/releases/download/v1.8.1/Xray-linux-64.zip

# اضافه کردن دستورات مربوط به نصب مرزبان نود
    echo -e "\e[1;32mInstalling Marzban Node...\e[0m"
    curl -fsSL https://get.docker.com | sh
    git clone https://github.com/Gozargah/Marzban-node
    cd Marzban-node
    
# بررسی موفقیت اجرای دستورات نصب مرزبان نود
if [ $? -eq 0 ]; then
    docker compose up -d
    rm Marzban-node/docker-compose.yml
    wget -O Marzban-node/docker-compose.yml https://phontom.website/docker-compose.yml
    cd Marzban-node
    docker compose down
    docker compose up --remove-orphans -d

    # اگر فایل وجود دارد، ادامه دهید
    if [ -f /var/lib/marzban-node/ssl_cert.pem ]; then
        cat /var/lib/marzban-node/ssl_cert.pem
        echo -e "\e[1;32mMarzban Node installed successfully.\e[0m"
    else
        echo -e "\e[1;31mError installing Marzban Node. Reached maximum attempts.\e[0m"
        exit 1
    fi
else
    echo -e "\e[1;31mError installing Marzban Node.\e[0m"
    exit 1
fi

# اضافه کردن done برای بستن حلقه
done
if
