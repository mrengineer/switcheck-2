
Based on  Red Pitaya Notes
http://pavel-demin.github.io/red-pitaya-notes/

SEE https://pavel-demin.github.io/red-pitaya-notes/alpine/

# IMPORTANT
- Увеличивая размер сообщения в AXI шине будешь увеличивать между измерениями шаг счетчика. Так 128 бит-ное сообщени несет в себе шаг в 4 ед счетчика
- 0 по АЦП смещен на 1/2 VDD. АЦП 14 бит => 0 это 8192 ед АЦП.


ПримерIdx  | Counter     | Dcnt    | ADC_A | ADC_B | SUM_ABS |  ABS_A+B | Marker
-----+------------+------+-------+-------+--------+---------+--------
  0 |           5 |       0 |  8157 |  8161 |  16317 |   16318 | 0xA1B2
  1 |           9 |       4 |  8156 |  8162 |  16325 |   16318 | 0xA1B2
  2 |          13 |       4 |  8158 |  8161 |  16314 |   16319 | 0xA1B2
  3 |          17 |       4 |  8155 |  8162 |  16316 |   16317 | 0xA1B2
  4 |          21 |       4 |  8155 |  8167 |  16319 |   16322 | 0xA1B2
  5 |          25 |       4 |  8158 |  8166 |  16328 |   16324 | 0xA1B2
  6 |          29 |       4 |  8156 |  8164 |  16322 |   16320 | 0xA1B2
  7 |          33 |       4 |  8156 |  8164 |  16321 |   16320 | 0xA1B2
  8 |          37 |       4 |  8156 |  8162 |  16323 |   16318 | 0xA1B2
  9 |          41 |       4 |  8155 |  8164 |  16322 |   16319 | 0xA1B2
  
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
