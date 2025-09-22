// (c) Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// (c) Copyright 2022-2025 Advanced Micro Devices, Inc. All rights reserved.
// 
// This file contains confidential and proprietary information
// of AMD and is protected under U.S. and international copyright
// and other intellectual property laws.
// 
// DISCLAIMER
// This disclaimer is not a license and does not grant any
// rights to the materials distributed herewith. Except as
// otherwise provided in a valid license issued to you by
// AMD, and to the maximum extent permitted by applicable
// law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
// WITH ALL FAULTS, AND AMD HEREBY DISCLAIMS ALL WARRANTIES
// AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
// BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
// INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
// (2) AMD shall not be liable (whether in contract or tort,
// including negligence, or under any other theory of
// liability) for any loss or damage of any kind or nature
// related to, arising under or in connection with these
// materials, including for any direct, or any indirect,
// special, incidental, or consequential loss or damage
// (including loss of data, profits, goodwill, or any type of
// loss or damage suffered as a result of any action brought
// by a third party) even if such damage or loss was
// reasonably foreseeable or AMD had been advised of the
// possibility of the same.
// 
// CRITICAL APPLICATIONS
// AMD products are not designed or intended to be fail-
// safe, or for use in any application requiring fail-safe
// performance, such as life-support or safety devices or
// systems, Class III medical devices, nuclear facilities,
// applications related to the deployment of airbags, or any
// other applications that could lead to death, personal
// injury, or severe property or environmental damage
// (individually and collectively, "Critical
// Applications"). Customer assumes the sole risk and
// liability of any use of AMD products in Critical
// Applications, subject only to applicable laws and
// regulations governing limitations on product liability.
// 
// THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
// PART OF THIS FILE AT ALL TIMES.
// 
// DO NOT MODIFY THIS FILE.


// IP VLNV: xilinx.com:module_ref:cfg_unpack:1.0
// IP Revision: 1

(* X_CORE_INFO = "cfg_unpack,Vivado 2023.2" *)
(* CHECK_LICENSE_TYPE = "system_cfg_unpack_0_0,cfg_unpack,{}" *)
(* CORE_GENERATION_INFO = "system_cfg_unpack_0_0,cfg_unpack,{x_ipProduct=Vivado 2023.2,x_ipVendor=xilinx.com,x_ipLibrary=module_ref,x_ipName=cfg_unpack,x_ipVersion=1.0,x_ipCoreRevision=1,x_ipLanguage=VERILOG,x_ipSimLanguage=VERILOG,CFG_DATA_WIDTH=160,RX_RST_LSB=0,RX_RST_WIDTH=8,RX_RATE_LSB=16,RX_RATE_WIDTH=16,RX_ADDR_LSB=32,RX_ADDR_WIDTH=32,TRG_VALUE_LSB=64,TRG_VALUE_WIDTH=16,LIMITER_LSB=80,LIMITER_WIDTH=8,BIAS_A_LSB=96,BIAS_A_WIDTH=16,BIAS_B_LSB=112,BIAS_B_WIDTH=16}" *)
(* IP_DEFINITION_SOURCE = "module_ref" *)
(* DowngradeIPIdentifiedWarnings = "yes" *)
module system_cfg_unpack_0_0 (
  cfg_data,
  nreset_adc,
  nreset_axis_writer,
  nreset_trg,
  nreset_max_sum,
  rx_rate,
  rx_addr,
  trg_value,
  limiter,
  bias_ch_A,
  bias_ch_B
);

input wire [159 : 0] cfg_data;
output wire nreset_adc;
output wire nreset_axis_writer;
output wire nreset_trg;
output wire nreset_max_sum;
output wire [15 : 0] rx_rate;
output wire [31 : 0] rx_addr;
output wire [15 : 0] trg_value;
output wire [7 : 0] limiter;
output wire [15 : 0] bias_ch_A;
output wire [15 : 0] bias_ch_B;

  cfg_unpack #(
    .CFG_DATA_WIDTH(160),
    .RX_RST_LSB(0),
    .RX_RST_WIDTH(8),
    .RX_RATE_LSB(16),
    .RX_RATE_WIDTH(16),
    .RX_ADDR_LSB(32),
    .RX_ADDR_WIDTH(32),
    .TRG_VALUE_LSB(64),
    .TRG_VALUE_WIDTH(16),
    .LIMITER_LSB(80),
    .LIMITER_WIDTH(8),
    .BIAS_A_LSB(96),
    .BIAS_A_WIDTH(16),
    .BIAS_B_LSB(112),
    .BIAS_B_WIDTH(16)
  ) inst (
    .cfg_data(cfg_data),
    .nreset_adc(nreset_adc),
    .nreset_axis_writer(nreset_axis_writer),
    .nreset_trg(nreset_trg),
    .nreset_max_sum(nreset_max_sum),
    .rx_rate(rx_rate),
    .rx_addr(rx_addr),
    .trg_value(trg_value),
    .limiter(limiter),
    .bias_ch_A(bias_ch_A),
    .bias_ch_B(bias_ch_B)
  );
endmodule
