# --@PvBoy--

# اضافه کردن جلوه‌های بصری به پیام‌های سازنده
clear
echo -e "\e[1;32m***********************"
echo -e "*******Made by Boy*******"
echo -e "***********************\e[0m"

# تنظیم ساعت به وقت ایران
export TZ="Asia/Tehran"

# نمایش تاریخ و ساعت ایران
echo -e "\e[1;36m$(date "+%Y/%m/%d|%H:%M:%S")\e[0m"

# نصب مرزبان نود در حال انجام است با جلوه چرخشی
echo -n "-Node installation is in progress... "
spinner="/|\\-"
while true; do
    for i in $(seq 0 3); do
        echo -ne "\e[1D${spinner:$i:1}"
        sleep 0.1
    done
done

# نصب وارپ
read -p "آیا مایل به نصب وارپ هستید؟ (y/n): " install_warp
if [ "$install_warp" == "y" ]; then
    wget https://github.com/ViRb3/wgcf/releases/download/v2.2.18/wgcf_2.2.18_linux_amd64
    mv wgcf_2.2.18_linux_amd64 /usr/bin/wgcf
    chmod +x /usr/bin/wgcf
    wgcf register --accept-tos
    wgcf generate
    sudo apt install wireguard-dkms wireguard-tools resolvconf -y
    mv wgcf-profile.conf warp.conf
    sudo mv warp.conf /etc/wireguard/
    sudo sed -i '7i\Table = off' /etc/wireguard/warp.conf
    sudo systemctl enable --now wg-quick@warp
    echo "WireGuard (Warp) installed successfully."
else
    echo "Skipping WireGuard (Warp) installation."
fi

# نصب هسته و ادیتش
# TODO: اضافه کردن دستورات مربوط به نصب هسته و ادیت هسته

# اضافه کردن فایل‌های مورد نیاز
# TODO: اضافه کردن دستورات مربوط به اضافه کردن فایل‌های مورد نیاز

# نصب مرزبان نود
# TODO: اضافه کردن دستورات مربوط به نصب مرزبان نود


حالا این اسکریپت ابتدا از کاربر می‌پرسد که آیا می‌خواهید WireGuard (Warp) نصب شود یا خیر. اگر جواب مثبت باشد، این بخش اجرا می‌شود و بعد از آن سایر مراحل اسکریپت به ترتیب اجرا می‌شوند.
