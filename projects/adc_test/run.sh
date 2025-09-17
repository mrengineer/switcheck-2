#! /bin/sh

apps_dir=/media/mmcblk0p1/apps


cat $apps_dir/system_wrapper.bit > /dev/xdevcfg

#$apps_dir/adc

cd $apps_dir

pkill tcpserver     #kill http server
#./websocketd --port=80 --staticdir=. ./adc
./adc

#dd if=/dev/mem bs=1 count=128 skip=$((0x1C500000)) 2>/dev/null | xxd