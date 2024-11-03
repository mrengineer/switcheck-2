transcript off
onbreak {quit -force}
onerror {quit -force}
transcript on

asim +access +r +m+system  -L xilinx_vip -L xpm -L xil_defaultlib -L axi_infrastructure_v1_1_0 -L axi_vip_v1_1_15 -L processing_system7_vip_v1_0_17 -L xlconstant_v1_1_8 -L lib_cdc_v1_0_2 -L proc_sys_reset_v5_0_14 -L xilinx_vip -L unisims_ver -L unimacro_ver -L secureip -O2 xil_defaultlib.system xil_defaultlib.glbl

do {system.udo}

run

endsim

quit -force
