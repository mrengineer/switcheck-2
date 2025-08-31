
Based on  Red Pitaya Notes
http://pavel-demin.github.io/red-pitaya-notes/

SEE https://pavel-demin.github.io/red-pitaya-notes/alpine/

# IMPORTANT
- Увеличивая размер сообщения в AXI шине будешь увеличивать между измерениями шаг счетчика. Так 128 бит-ное сообщени несет в себе шаг в 4 ед счетчика
- 0 по АЦП смещен на 1/2 VDD. АЦП 14 бит => 0 это 8192 ед АЦП.
- Возможно, драйвер CMA ве же работает нормально с S_AXI_ACP, а при HP0 в памяти появляются при повторных запусках странные нули. Решил остаться на ACP. Тем более что ускорения работы я не получаю и приходится ужимать содержимое протокола.

# Примечания
  
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
