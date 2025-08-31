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


// IP VLNV: xilinx.com:module_ref:ADC:1.0
// IP Revision: 1

`timescale 1ns/1ps

(* IP_DEFINITION_SOURCE = "module_ref" *)
(* DowngradeIPIdentifiedWarnings = "yes" *)
module system_ADC_1_0 (
  aclk,
  aresetn,
  adc_csn,
  adc_dat_a,
  adc_dat_b,
  cur_adc,
  cur_sample,
  limiter,
  trigger_level,
  reset_trigger,
  reset_max_sum,
  m_axis_tvalid,
  m_axis_tdata,
  max_sum_out,
  last_detrigged,
  first_trigged,
  cur_limiter,
  samples_sent,
  trigger_activated,
  triggers_count
);

(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME aclk, ASSOCIATED_BUSIF m_axis, ASSOCIATED_RESET aresetn, FREQ_HZ 125000000, FREQ_TOLERANCE_HZ 0, PHASE 0.0, CLK_DOMAIN system_pll_0_0_clk_out1, INSERT_VIP 0" *)
(* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 aclk CLK" *)
input wire aclk;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME aresetn, POLARITY ACTIVE_LOW, INSERT_VIP 0" *)
(* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 aresetn RST" *)
input wire aresetn;
output wire adc_csn;
input wire [15 : 0] adc_dat_a;
input wire [15 : 0] adc_dat_b;
output wire [15 : 0] cur_adc;
output wire [63 : 0] cur_sample;
input wire [7 : 0] limiter;
input wire [15 : 0] trigger_level;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME reset_trigger, POLARITY ACTIVE_LOW, INSERT_VIP 0" *)
(* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 reset_trigger RST" *)
input wire reset_trigger;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME reset_max_sum, POLARITY ACTIVE_LOW, INSERT_VIP 0" *)
(* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 reset_max_sum RST" *)
input wire reset_max_sum;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 m_axis TVALID" *)
output wire m_axis_tvalid;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME m_axis, TDATA_NUM_BYTES 4, TDEST_WIDTH 0, TID_WIDTH 0, TUSER_WIDTH 0, HAS_TREADY 0, HAS_TSTRB 0, HAS_TKEEP 0, HAS_TLAST 0, FREQ_HZ 125000000, PHASE 0.0, CLK_DOMAIN system_pll_0_0_clk_out1, LAYERED_METADATA undef, INSERT_VIP 0" *)
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 m_axis TDATA" *)
output wire [31 : 0] m_axis_tdata;
output wire [15 : 0] max_sum_out;
output wire [63 : 0] last_detrigged;
output wire [63 : 0] first_trigged;
output wire [63 : 0] cur_limiter;
output wire [31 : 0] samples_sent;
output wire trigger_activated;
output wire [15 : 0] triggers_count;

  ADC #(
    .ADC_DATA_WIDTH(14)
  ) inst (
    .aclk(aclk),
    .aresetn(aresetn),
    .adc_csn(adc_csn),
    .adc_dat_a(adc_dat_a),
    .adc_dat_b(adc_dat_b),
    .cur_adc(cur_adc),
    .cur_sample(cur_sample),
    .limiter(limiter),
    .trigger_level(trigger_level),
    .reset_trigger(reset_trigger),
    .reset_max_sum(reset_max_sum),
    .m_axis_tvalid(m_axis_tvalid),
    .m_axis_tdata(m_axis_tdata),
    .max_sum_out(max_sum_out),
    .last_detrigged(last_detrigged),
    .first_trigged(first_trigged),
    .cur_limiter(cur_limiter),
    .samples_sent(samples_sent),
    .trigger_activated(trigger_activated),
    .triggers_count(triggers_count)
  );
endmodule
