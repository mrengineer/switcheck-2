#! /bin/sh

apps_dir=/media/mmcblk0p1/apps


cat $apps_dir/system_wrapper.bit > /dev/xdevcfg

$apps_dir/adcrec
