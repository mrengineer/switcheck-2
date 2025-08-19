#!/bin/bash

rm -f ./system_wrapper.bit
cp ~/red-pitaya-notes/tmp/adc_test.runs/impl_1/system_wrapper.bit .

#SHH and prepare for write
echo y | ssh-keygen -f '/home/bulkin/.ssh/known_hosts' -R '192.168.1.8'
sshpass -p 'changeme' ssh -t sdr-rw        #calls from .ssh/config with RemoteCommand mount -o rw,remount /media/mmcblk0p1

sshpass -p 'changeme' scp ./system_wrapper.bit ./run.sh ./adc root@sdr:/root/apps/
#sshpass -p 'changeme' scp ./websocketd root@sdr:/root/apps/

sshpass -p 'changeme' ssh -t sdr 'sync'

sshpass -p 'changeme' ssh -t sdr-ro        #calls from .ssh/config with RemoteCommand mount -o ro,remount /media/mmcblk0p1
sshpass -p 'changeme' ssh -t sdr 'sync; /root/apps/run.sh'
#sshpass -p 'changeme' ssh -t sdr '/root/apps/websocketd'


