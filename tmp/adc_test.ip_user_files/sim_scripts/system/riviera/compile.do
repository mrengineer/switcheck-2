transcript off
onbreak {quit -force}
onerror {quit -force}
transcript on

vlib work
vlib riviera/xilinx_vip
vlib riviera/xpm
vlib riviera/xil_defaultlib
vlib riviera/axi_infrastructure_v1_1_0
vlib riviera/axi_vip_v1_1_15
vlib riviera/processing_system7_vip_v1_0_17
vlib riviera/xlconstant_v1_1_8
vlib riviera/lib_cdc_v1_0_2
vlib riviera/proc_sys_reset_v5_0_14

vmap xilinx_vip riviera/xilinx_vip
vmap xpm riviera/xpm
vmap xil_defaultlib riviera/xil_defaultlib
vmap axi_infrastructure_v1_1_0 riviera/axi_infrastructure_v1_1_0
vmap axi_vip_v1_1_15 riviera/axi_vip_v1_1_15
vmap processing_system7_vip_v1_0_17 riviera/processing_system7_vip_v1_0_17
vmap xlconstant_v1_1_8 riviera/xlconstant_v1_1_8
vmap lib_cdc_v1_0_2 riviera/lib_cdc_v1_0_2
vmap proc_sys_reset_v5_0_14 riviera/proc_sys_reset_v5_0_14

vlog -work xilinx_vip  -incr "+incdir+/home/bulkin/Xilinx/Vivado/2023.2/data/xilinx_vip/include" -l xilinx_vip -l xpm -l xil_defaultlib -l axi_infrastructure_v1_1_0 -l axi_vip_v1_1_15 -l processing_system7_vip_v1_0_17 -l xlconstant_v1_1_8 -l lib_cdc_v1_0_2 -l proc_sys_reset_v5_0_14 \
"/home/bulkin/Xilinx/Vivado/2023.2/data/xilinx_vip/hdl/axi4stream_vip_axi4streampc.sv" \
"/home/bulkin/Xilinx/Vivado/2023.2/data/xilinx_vip/hdl/axi_vip_axi4pc.sv" \
"/home/bulkin/Xilinx/Vivado/2023.2/data/xilinx_vip/hdl/xil_common_vip_pkg.sv" \
"/home/bulkin/Xilinx/Vivado/2023.2/data/xilinx_vip/hdl/axi4stream_vip_pkg.sv" \
"/home/bulkin/Xilinx/Vivado/2023.2/data/xilinx_vip/hdl/axi_vip_pkg.sv" \
"/home/bulkin/Xilinx/Vivado/2023.2/data/xilinx_vip/hdl/axi4stream_vip_if.sv" \
"/home/bulkin/Xilinx/Vivado/2023.2/data/xilinx_vip/hdl/axi_vip_if.sv" \
"/home/bulkin/Xilinx/Vivado/2023.2/data/xilinx_vip/hdl/clk_vip_if.sv" \
"/home/bulkin/Xilinx/Vivado/2023.2/data/xilinx_vip/hdl/rst_vip_if.sv" \

vlog -work xpm  -incr "+incdir+../../../../adc_test.gen/sources_1/bd/system/ipshared/c2c6" "+incdir+../../../../adc_test.gen/sources_1/bd/system/ipshared/ec67/hdl" "+incdir+../../../../adc_test.gen/sources_1/bd/system/ipshared/6b2b/hdl" "+incdir+/home/bulkin/Xilinx/Vivado/2023.2/data/xilinx_vip/include" -l xilinx_vip -l xpm -l xil_defaultlib -l axi_infrastructure_v1_1_0 -l axi_vip_v1_1_15 -l processing_system7_vip_v1_0_17 -l xlconstant_v1_1_8 -l lib_cdc_v1_0_2 -l proc_sys_reset_v5_0_14 \
"/home/bulkin/Xilinx/Vivado/2023.2/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \
"/home/bulkin/Xilinx/Vivado/2023.2/data/ip/xpm/xpm_fifo/hdl/xpm_fifo.sv" \
"/home/bulkin/Xilinx/Vivado/2023.2/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \

vcom -work xpm -93  -incr \
"/home/bulkin/Xilinx/Vivado/2023.2/data/ip/xpm/xpm_VCOMP.vhd" \

vlog -work xil_defaultlib  -incr -v2k5 "+incdir+../../../../adc_test.gen/sources_1/bd/system/ipshared/c2c6" "+incdir+../../../../adc_test.gen/sources_1/bd/system/ipshared/ec67/hdl" "+incdir+../../../../adc_test.gen/sources_1/bd/system/ipshared/6b2b/hdl" "+incdir+/home/bulkin/Xilinx/Vivado/2023.2/data/xilinx_vip/include" -l xilinx_vip -l xpm -l xil_defaultlib -l axi_infrastructure_v1_1_0 -l axi_vip_v1_1_15 -l processing_system7_vip_v1_0_17 -l xlconstant_v1_1_8 -l lib_cdc_v1_0_2 -l proc_sys_reset_v5_0_14 \
"../../../bd/system/ip/system_pll_0_0/system_pll_0_0_clk_wiz.v" \
"../../../bd/system/ip/system_pll_0_0/system_pll_0_0.v" \

vlog -work axi_infrastructure_v1_1_0  -incr -v2k5 "+incdir+../../../../adc_test.gen/sources_1/bd/system/ipshared/c2c6" "+incdir+../../../../adc_test.gen/sources_1/bd/system/ipshared/ec67/hdl" "+incdir+../../../../adc_test.gen/sources_1/bd/system/ipshared/6b2b/hdl" "+incdir+/home/bulkin/Xilinx/Vivado/2023.2/data/xilinx_vip/include" -l xilinx_vip -l xpm -l xil_defaultlib -l axi_infrastructure_v1_1_0 -l axi_vip_v1_1_15 -l processing_system7_vip_v1_0_17 -l xlconstant_v1_1_8 -l lib_cdc_v1_0_2 -l proc_sys_reset_v5_0_14 \
"../../../../adc_test.gen/sources_1/bd/system/ipshared/ec67/hdl/axi_infrastructure_v1_1_vl_rfs.v" \

vlog -work axi_vip_v1_1_15  -incr "+incdir+../../../../adc_test.gen/sources_1/bd/system/ipshared/c2c6" "+incdir+../../../../adc_test.gen/sources_1/bd/system/ipshared/ec67/hdl" "+incdir+../../../../adc_test.gen/sources_1/bd/system/ipshared/6b2b/hdl" "+incdir+/home/bulkin/Xilinx/Vivado/2023.2/data/xilinx_vip/include" -l xilinx_vip -l xpm -l xil_defaultlib -l axi_infrastructure_v1_1_0 -l axi_vip_v1_1_15 -l processing_system7_vip_v1_0_17 -l xlconstant_v1_1_8 -l lib_cdc_v1_0_2 -l proc_sys_reset_v5_0_14 \
"../../../../adc_test.gen/sources_1/bd/system/ipshared/5753/hdl/axi_vip_v1_1_vl_rfs.sv" \

vlog -work processing_system7_vip_v1_0_17  -incr "+incdir+../../../../adc_test.gen/sources_1/bd/system/ipshared/c2c6" "+incdir+../../../../adc_test.gen/sources_1/bd/system/ipshared/ec67/hdl" "+incdir+../../../../adc_test.gen/sources_1/bd/system/ipshared/6b2b/hdl" "+incdir+/home/bulkin/Xilinx/Vivado/2023.2/data/xilinx_vip/include" -l xilinx_vip -l xpm -l xil_defaultlib -l axi_infrastructure_v1_1_0 -l axi_vip_v1_1_15 -l processing_system7_vip_v1_0_17 -l xlconstant_v1_1_8 -l lib_cdc_v1_0_2 -l proc_sys_reset_v5_0_14 \
"../../../../adc_test.gen/sources_1/bd/system/ipshared/6b2b/hdl/processing_system7_vip_v1_0_vl_rfs.sv" \

vlog -work xil_defaultlib  -incr -v2k5 "+incdir+../../../../adc_test.gen/sources_1/bd/system/ipshared/c2c6" "+incdir+../../../../adc_test.gen/sources_1/bd/system/ipshared/ec67/hdl" "+incdir+../../../../adc_test.gen/sources_1/bd/system/ipshared/6b2b/hdl" "+incdir+/home/bulkin/Xilinx/Vivado/2023.2/data/xilinx_vip/include" -l xilinx_vip -l xpm -l xil_defaultlib -l axi_infrastructure_v1_1_0 -l axi_vip_v1_1_15 -l processing_system7_vip_v1_0_17 -l xlconstant_v1_1_8 -l lib_cdc_v1_0_2 -l proc_sys_reset_v5_0_14 \
"../../../bd/system/ip/system_ps_0_0/sim/system_ps_0_0.v" \

vlog -work xlconstant_v1_1_8  -incr -v2k5 "+incdir+../../../../adc_test.gen/sources_1/bd/system/ipshared/c2c6" "+incdir+../../../../adc_test.gen/sources_1/bd/system/ipshared/ec67/hdl" "+incdir+../../../../adc_test.gen/sources_1/bd/system/ipshared/6b2b/hdl" "+incdir+/home/bulkin/Xilinx/Vivado/2023.2/data/xilinx_vip/include" -l xilinx_vip -l xpm -l xil_defaultlib -l axi_infrastructure_v1_1_0 -l axi_vip_v1_1_15 -l processing_system7_vip_v1_0_17 -l xlconstant_v1_1_8 -l lib_cdc_v1_0_2 -l proc_sys_reset_v5_0_14 \
"../../../../adc_test.gen/sources_1/bd/system/ipshared/d390/hdl/xlconstant_v1_1_vl_rfs.v" \

vlog -work xil_defaultlib  -incr -v2k5 "+incdir+../../../../adc_test.gen/sources_1/bd/system/ipshared/c2c6" "+incdir+../../../../adc_test.gen/sources_1/bd/system/ipshared/ec67/hdl" "+incdir+../../../../adc_test.gen/sources_1/bd/system/ipshared/6b2b/hdl" "+incdir+/home/bulkin/Xilinx/Vivado/2023.2/data/xilinx_vip/include" -l xilinx_vip -l xpm -l xil_defaultlib -l axi_infrastructure_v1_1_0 -l axi_vip_v1_1_15 -l processing_system7_vip_v1_0_17 -l xlconstant_v1_1_8 -l lib_cdc_v1_0_2 -l proc_sys_reset_v5_0_14 \
"../../../bd/system/ip/system_const_0_0/sim/system_const_0_0.v" \

vcom -work lib_cdc_v1_0_2 -93  -incr \
"../../../../adc_test.gen/sources_1/bd/system/ipshared/ef1e/hdl/lib_cdc_v1_0_rfs.vhd" \

vcom -work proc_sys_reset_v5_0_14 -93  -incr \
"../../../../adc_test.gen/sources_1/bd/system/ipshared/408c/hdl/proc_sys_reset_v5_0_vh_rfs.vhd" \

vcom -work xil_defaultlib -93  -incr \
"../../../bd/system/ip/system_rst_0_0/sim/system_rst_0_0.vhd" \

vlog -work xil_defaultlib  -incr -v2k5 "+incdir+../../../../adc_test.gen/sources_1/bd/system/ipshared/c2c6" "+incdir+../../../../adc_test.gen/sources_1/bd/system/ipshared/ec67/hdl" "+incdir+../../../../adc_test.gen/sources_1/bd/system/ipshared/6b2b/hdl" "+incdir+/home/bulkin/Xilinx/Vivado/2023.2/data/xilinx_vip/include" -l xilinx_vip -l xpm -l xil_defaultlib -l axi_infrastructure_v1_1_0 -l axi_vip_v1_1_15 -l processing_system7_vip_v1_0_17 -l xlconstant_v1_1_8 -l lib_cdc_v1_0_2 -l proc_sys_reset_v5_0_14 \
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

