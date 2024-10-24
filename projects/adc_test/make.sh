#!/bin/bash
rm ./adc
arm-linux-gnueabihf-gcc -static -O3 -march=armv7-a -mtune=cortex-a9 -mfpu=neon -mfloat-abi=hard ./adc.c -D_GNU_SOURCE -lm -lpthread -o adc
rm ./system_wrapper.bit
cp ~/red-pitaya-notes/tmp/adc_test.runs/impl_1/system_wrapper.bit .

#SHH and prepare for write
echo y | ssh-keygen -f '/home/bulkin/.ssh/known_hosts' -R '192.168.1.8'
sshpass -p 'changeme' ssh -t sdr-rw        #calls from .ssh/config with RemoteCommand mount -o rw,remount /media/mmcblk0p1

sshpass -p 'changeme' scp ./system_wrapper.bit root@sdr:/root/apps/
sshpass -p 'changeme' scp ./run.sh root@sdr:/root/apps/
sshpass -p 'changeme' scp ./adc root@sdr:/root/apps/

sshpass -p 'changeme' ssh -t sdr 'sync'
sshpass -p 'changeme' ssh -t sdr-ro        #calls from .ssh/config with RemoteCommand mount -o ro,remount /media/mmcblk0p1

sshpass -p 'changeme' ssh -t sdr '/root/apps/run.sh'