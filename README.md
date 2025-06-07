
Based on  Red Pitaya Notes
http://pavel-demin.github.io/red-pitaya-notes/

SEE https://pavel-demin.github.io/red-pitaya-notes/alpine/

# Autorun

/etc/local.d/apps.start
- создает туннель
- запускает start.sh с карты

rw - mmc RW

wo - mmc Readonly

lbu commit -d 0- commit changes to SD

# configure WPA supplicant
wpa_passphrase SSID PASSPHRASE > /etc/wpa_supplicant/wpa_supplicant.conf

# configure services for client Wi-Fi mode
./wifi/client.sh

# save configuration changes to SD card
lbu commit -d
