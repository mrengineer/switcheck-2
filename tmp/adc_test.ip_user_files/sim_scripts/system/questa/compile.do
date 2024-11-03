vlib questa_lib/work
vlib questa_lib/msim

vlib questa_lib/msim/xilinx_vip
vlib questa_lib/msim/xpm
vlib questa_lib/msim/xil_defaultlib
vlib questa_lib/msim/axi_infrastructure_v1_1_0
vlib questa_lib/msim/axi_vip_v1_1_15
vlib questa_lib/msim/processing_system7_vip_v1_0_17
vlib questa_lib/msim/xlconstant_v1_1_8
vlib questa_lib/msim/lib_cdc_v1_0_2
vlib questa_lib/msim/proc_sys_reset_v5_0_14

vmap xilinx_vip questa_lib/msim/xilinx_vip
vmap xpm questa_lib/msim/xpm
vmap xil_defaultlib questa_lib/msim/xil_defaultlib
vmap axi_infrastructure_v1_1_0 questa_lib/msim/axi_infrastructure_v1_1_0
vmap axi_vip_v1_1_15 questa_lib/msim/axi_vip_v1_1_15
vmap processing_system7_vip_v1_0_17 questa_lib/msim/processing_system7_vip_v1_0_17
vmap xlconstant_v1_1_8 questa_lib/msim/xlconstant_v1_1_8
vmap lib_cdc_v1_0_2 questa_lib/msim/lib_cdc_v1_0_2
vmap proc_sys_reset_v5_0_14 questa_lib/msim/proc_sys_reset_v5_0_14

vlog -work xilinx_vip -64 -incr -mfcu  -sv -L axi_vip_v1_1_15 -L processing_system7_vip_v1_0_17 -L xilinx_vip "+incdir+/home/bulkin/Xilinx/Vivado/2023.2/data/xilinx_vip/include" \
"/home/bulkin/Xilinx/Vivado/2023.2/data/xilinx_vip/hdl/axi4stream_vip_axi4streampc.sv" \
"/home/bulkin/Xilinx/Vivado/2023.2/data/xilinx_vip/hdl/axi_vip_axi4pc.sv" \
"/home/bulkin/Xilinx/Vivado/2023.2/data/xilinx_vip/hdl/xil_common_vip_pkg.sv" \
"/home/bulkin/Xilinx/Vivado/2023.2/data/xilinx_vip/hdl/axi4stream_vip_pkg.sv" \
"/home/bulkin/Xilinx/Vivado/2023.2/data/xilinx_vip/hdl/axi_vip_pkg.sv" \
"/home/bulkin/Xilinx/Vivado/2023.2/data/xilinx_vip/hdl/axi4stream_vip_if.sv" \
"/home/bulkin/Xilinx/Vivado/2023.2/data/xilinx_vip/hdl/axi_vip_if.sv" \
"/home/bulkin/Xilinx/Vivado/2023.2/data/xilinx_vip/hdl/clk_vip_if.sv" \
"/home/bulkin/Xilinx/Vivado/2023.2/data/xilinx_vip/hdl/rst_vip_if.sv" \

vlog -work xpm -64 -incr -mfcu  -sv -L axi_vip_v1_1_15 -L processing_system7_vip_v1_0_17 -L xilinx_vip "+incdir+../../../../adc_test.gen/sources_1/bd/system/ipshared/c2c6" "+incdir+../../../../adc_test.gen/sources_1/bd/system/ipshared/ec67/hdl" "+incdir+../../../../adc_test.gen/sources_1/bd/system/ipshared/6b2b/hdl" "+incdir+/home/bulkin/Xilinx/Vivado/2023.2/data/xilinx_vip/include" \
"/home/bulkin/Xilinx/Vivado/2023.2/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \
"/home/bulkin/Xilinx/Vivado/2023.2/data/ip/xpm/xpm_fifo/hdl/xpm_fifo.sv" \
"/home/bulkin/Xilinx/Vivado/2023.2/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \

vcom -work xpm -64 -93  \
"/home/bulkin/Xilinx/Vivado/2023.2/data/ip/xpm/xpm_VCOMP.vhd" \

vlog -work xil_defaultlib -64 -incr -mfcu  "+incdir+../../../../adc_test.gen/sources_1/bd/system/ipshared/c2c6" "+incdir+../../../../adc_test.gen/sources_1/bd/system/ipshared/ec67/hdl" "+incdir+../../../../adc_test.gen/sources_1/bd/system/ipshared/6b2b/hdl" "+incdir+/home/bulkin/Xilinx/Vivado/2023.2/data/xilinx_vip/include" \
"../../../bd/system/ip/system_pll_0_0/system_pll_0_0_clk_wiz.v" \
"../../../bd/system/ip/system_pll_0_0/system_pll_0_0.v" \

vlog -work axi_infrastructure_v1_1_0 -64 -incr -mfcu  "+incdir+../../../../adc_test.gen/sources_1/bd/system/ipshared/c2c6" "+incdir+../../../../adc_test.gen/sources_1/bd/system/ipshared/ec67/hdl" "+incdir+../../../../adc_test.gen/sources_1/bd/system/ipshared/6b2b/hdl" "+incdir+/home/bulkin/Xilinx/Vivado/2023.2/data/xilinx_vip/include" \
"../../../../adc_test.gen/sources_1/bd/system/ipshared/ec67/hdl/axi_infrastructure_v1_1_vl_rfs.v" \

vlog -work axi_vip_v1_1_15 -64 -incr -mfcu  -sv -L axi_vip_v1_1_15 -L processing_system7_vip_v1_0_17 -L xilinx_vip "+incdir+../../../../adc_test.gen/sources_1/bd/system/ipshared/c2c6" "+incdir+../../../../adc_test.gen/sources_1/bd/system/ipshared/ec67/hdl" "+incdir+../../../../adc_test.gen/sources_1/bd/system/ipshared/6b2b/hdl" "+incdir+/home/bulkin/Xilinx/Vivado/2023.2/data/xilinx_vip/include" \
"../../../../adc_test.gen/sources_1/bd/system/ipshared/5753/hdl/axi_vip_v1_1_vl_rfs.sv" \

vlog -work processing_system7_vip_v1_0_17 -64 -incr -mfcu  -sv -L axi_vip_v1_1_15 -L processing_system7_vip_v1_0_17 -L xilinx_vip "+incdir+../../../../adc_test.gen/sources_1/bd/system/ipshared/c2c6" "+incdir+../../../../adc_test.gen/sources_1/bd/system/ipshared/ec67/hdl" "+incdir+../../../../adc_test.gen/sources_1/bd/system/ipshared/6b2b/hdl" "+incdir+/home/bulkin/Xilinx/Vivado/2023.2/data/xilinx_vip/include" \
"../../../../adc_test.gen/sources_1/bd/system/ipshared/6b2b/hdl/processing_system7_vip_v1_0_vl_rfs.sv" \

vlog -work xil_defaultlib -64 -incr -mfcu  "+incdir+../../../../adc_test.gen/sources_1/bd/system/ipshared/c2c6" "+incdir+../../../../adc_test.gen/sources_1/bd/system/ipshared/ec67/hdl" "+incdir+../../../../adc_test.gen/sources_1/bd/system/ipshared/6b2b/hdl" "+incdir+/home/bulkin/Xilinx/Vivado/2023.2/data/xilinx_vip/include" \
"../../../bd/system/ip/system_ps_0_0/sim/system_ps_0_0.v" \

vlog -work xlconstant_v1_1_8 -64 -incr -mfcu  "+incdir+../../../../adc_test.gen/sources_1/bd/system/ipshared/c2c6" "+incdir+../../../../adc_test.gen/sources_1/bd/system/ipshared/ec67/hdl" "+incdir+../../../../adc_test.gen/sources_1/bd/system/ipshared/6b2b/hdl" "+incdir+/home/bulkin/Xilinx/Vivado/2023.2/data/xilinx_vip/include" \
"../../../../adc_test.gen/sources_1/bd/system/ipshared/d390/hdl/xlconstant_v1_1_vl_rfs.v" \

vlog -work xil_defaultlib -64 -incr -mfcu  "+incdir+../../../../adc_test.gen/sources_1/bd/system/ipshared/c2c6" "+incdir+../../../../adc_test.gen/sources_1/bd/system/ipshared/ec67/hdl" "+incdir+../../../../adc_test.gen/sources_1/bd/system/ipshared/6b2b/hdl" "+incdir+/home/bulkin/Xilinx/Vivado/2023.2/data/xilinx_vip/include" \
"../../../bd/system/ip/system_const_0_0/sim/system_const_0_0.v" \

vcom -work lib_cdc_v1_0_2 -64 -93  \
"../../../../adc_test.gen/sources_1/bd/system/ipshared/ef1e/hdl/lib_cdc_v1_0_rfs.vhd" \

vcom -work proc_sys_reset_v5_0_14 -64 -93  \
"../../../../adc_test.gen/sources_1/bd/system/ipshared/408c/hdl/proc_sys_reset_v5_0_vh_rfs.vhd" \

vcom -work xil_defaultlib -64 -93  \
"../../../bd/system/ip/system_rst_0_0/sim/system_rst_0_0.vhd" \

vlog -work xil_defaultlib -64 -incr -mfcu  "+incdir+../../../../adc_test.gen/sources_1/bd/system/ipshared/c2c6" "+incdir+../../../../adc_test.gen/sources_1/bd/system/ipshared/ec67/hdl" "+incdir+../../../../adc_test.gen/sources_1/bd/system/ipshared/6b2b/hdl" "+incdir+/home/bulkin/Xilinx/Vivado/2023.2/data/xilinx_vip/include" \
"../../../bd/system/ipshared/modules/inout_buffer.v" \
"../../../bd/system/ipshared/modules/input_buffer.v" \
"../../../bd/system/ipshared/modules/output_buffer.v" \
"../../../bd/system/ipshared/cores/axi_hub.v" \
"../../../bd/system/ip/system_hub_0_0/sim/system_hub_0_0.v" \
"../../../bd/system/ipshared/cores/port_slicer.v" \
"../../../bd/system/ip/system_slice_0_0/sim/system_slice_0_0.v" \
"../../../bd/system/ip/system_slice_1_0/sim/system_slice_1_0.v" \
"../../../bd/system/ip/system_slice_2_0/sim/system_slice_2_0.v" \
"../../../bd/system/ip/system_slice_3_0/sim/system_slice_3_0.v" \
"../../../bd/system/ip/system_const_1_0/sim/system_const_1_0.v" \
"../../../bd/system/ipshared/cores/axis_ram_writer.v" \
"../../../bd/system/ip/system_writer_0_0/sim/system_writer_0_0.v" \
"../../../bd/system/ip/system_slice_4_0/sim/system_slice_4_0.v" \
"../../../bd/system/ip/system_slice_5_0/sim/system_slice_5_0.v" \
"../../../bd/system/ip/system_ADC_1_0/sim/system_ADC_1_0.v" \
"../../../bd/system/ip/system_axis_decimator_0_0/sim/system_axis_decimator_0_0.v" \
"../../../bd/system/ip/system_slice_1_1/sim/system_slice_1_1.v" \
"../../../bd/system/ip/system_slice_6_0/sim/system_slice_6_0.v" \
"../../../bd/system/sim/system.v" \

vlog -work xil_defaultlib \
"glbl.v"

