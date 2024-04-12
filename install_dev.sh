#!/bin/bash

# پاک کردن صفحه ترمینال
#clear

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
if [[ "$install_warp" == "y" ]] || [[ "$install_warp" == "Y" ]]; then
    # نصب وارپ و مراحل بعدی
    echo -e "\e[1;32mInstalling WireGuard (Warp)..."

    # اپدیت
    echo "running 'apt update' ..."
    sudo apt update -y > /dev/null 2>&1
    echo "update done"

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
    echo "installing 'wireguard' ..."
    sudo apt install wireguard-dkms wireguard-tools resolvconf -y > /dev/null 2>&1
    echo "wireguard installed"

    # دانلود و نصب wgcf
    echo "installing 'wgcf'..."
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
    sudo systemctl enable --now wg-quick@warp.service

    if systemctl is-active --quiet wg-quick@warp.service; then
        echo -e "\e[32m+++Successful wairgard warp...\e[0m"
    else
        echo -e "\e[31mError - Warp service failed to run!\e[0m"
        # نمایش وضعیت سرویس در صورت عدم موفقیت
        systemctl status wg-quick@warp
    fi
else
    #  میره تو وضعیتش که ارور رو ببینی و از اسکریپت خارج میشه
    echo -e ""
fi

while [[ -z "$INSTALL_TYPE" ]]; do
    echo "Install type? (d|m): "
    read -r INSTALL_TYPE
    if [[ $INSTALL_TYPE == $'\0' ]]; then
        echo "Invalid input. Chat id cannot be empty."
        unset INSTALL_TYPE
     elif [[ ! $INSTALL_TYPE =~ ^[md]$ ]]; then
        echo "${INSTALL_TYPE} is not a valid option. Please choose m or d."
        unset xmh
    fi
done

VERSION=""
while [[ -z "$INSTALL_VERSION" ]]; do
  echo "Version: "
  read -r INSTALL_VERSION
  if [[ ! $INSTALL_VERSION =~ ^v\d+\.\d+\.\d+$ ]]; then
    echo "Error: Invalid version number format. Please use format like 'v1.8.1'."
    unset INSTALL_VERSION
  else
    VERSION="--version $INSTALL_VERSION"
  fi
done

apt update -y > /dev/null 2>&1
apt install sudo -y > /dev/null 2>&1
apt-get install git -y > /dev/null 2>&1

cd "$HOME" || exit
git clone https://github.com/Gozargah/Marzban-node > /dev/null 2>&1

if [[ $INSTALL_TYPE = "m" ]]; then
    SERVICE_NAME="marzban-node"
    SERVICE_DOCUMENTATION="https://t.me/AC_Lover"
    MAIN_PY_PATH="$HOME/Marzban-node/main.py"
    SERVICE_FILE="/etc/systemd/system/$SERVICE_NAME.service"
    cat >$SERVICE_FILE <<EOF
[Unit]
Description=$SERVICE_DESCRIPTION
Documentation=$SERVICE_DOCUMENTATION
After=network.target nss-lookup.target

[Service]
Restart=on-failure
ExecStart=/usr/bin/env python3 $MAIN_PY_PATH
WorkingDirectory=$HOME/Marzban-node

[Install]
WantedBy=multi-user.target
EOF

echo "installing Xray"
bash -c "$(curl -L https://github.com/XTLS/Xray-install/raw/main/install-release.sh)" @ install "$VERSION"  > /dev/null 2>&1
echo "install Xray done"

wget -O "$HOME"/Marzban-node/.env https://host-upload-data-boy.site/node/.env

systemctl daemon-reload

sudo systemctl enable "$SERVICE_NAME".service

sudo systemctl start "$SERVICE_NAME".service

echo "Service file created at: $SERVICE_FILE"



else
echo "installing Xray"
bash -c "$(curl -L https://github.com/XTLS/Xray-install/raw/main/install-release.sh)" @ install "$VERSION" --without-logfiles  > /dev/null 2>&1
echo "install Xray done"
service xray.service stop
rm /etc/systemd/system/xray.service
rm /etc/systemd/system/xray@.service
systemctl daemon-reload

mkdir -p /var/lib/marzban-node

cp /usr/local/bin/xray /var/lib/marzban-node/xray

echo -e "\e[1;31m -Install Marzban node + Docker\e[0m"
curl -fsSL https://get.docker.com | sh > /dev/null 2>&1

(cd "$HOME"/Marzban-node && docker compose up -d)
rm "$HOME"/Marzban-node/docker-compose.yml
wget -O "$HOME"/Marzban-node/docker-compose.yml https://host-upload-data-boy.site/node/docker-compose.yml
wget -O /var/lib/marzban-node/ssl_client_cert.pem https://host-upload-data-boy.site/node/ssl_client_cert.pem
(cd "$HOME"/Marzban-node && docker compose down && docker compose up --remove-orphans -d)

fi


# TODO: اضافه کردن دستورات مربوط به اضافه کردن فایل‌های مورد نیاز
echo -e "\e[1;31m +Adding required files....\e[0m"
wget -O /usr/local/share/xray/iran.dat https://github.com/bootmortis/iran-hosted-domains/releases/download/202308070029/iran.dat

# تموم
echo -e "\e[94mFinish (⁠✯⁠ᴗ⁠✯⁠)\e[0m"
