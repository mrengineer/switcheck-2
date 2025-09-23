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


// IP VLNV: xilinx.com:module_ref:sts_pack:1.0
// IP Revision: 1

`timescale 1ns/1ps

(* IP_DEFINITION_SOURCE = "module_ref" *)
(* DowngradeIPIdentifiedWarnings = "yes" *)
module system_sts_pack_0_0 (
  rx_cntr,
  adc_abs_max,
  cur_adc,
  last_detrigged,
  first_trgged,
  adc_sent,
  trigger_activated,
  triggers_count,
  samples_count,
  cur_adc_a,
  cur_adc_b,
  sts_bus
);

input wire [31 : 0] rx_cntr;
input wire [15 : 0] adc_abs_max;
input wire [15 : 0] cur_adc;
input wire [63 : 0] last_detrigged;
input wire [63 : 0] first_trgged;
input wire [31 : 0] adc_sent;
input wire [15 : 0] trigger_activated;
input wire [15 : 0] triggers_count;
input wire [63 : 0] samples_count;
input wire [15 : 0] cur_adc_a;
input wire [15 : 0] cur_adc_b;
output wire [639 : 0] sts_bus;

  sts_pack #(
    .TOTAL_WIDTH(640),
    .WIDTH_RX_CNTR(32),
    .WIDTH_ADC_ABS_MAX(16),
    .WIDTH_CUR_ADC(16),
    .WIDTH_LAST_DETRIGGED(64),
    .WIDTH_FIRST_TRGGED(64),
    .WIDTH_ADC_SENT(32),
    .WIDTH_TRIG_ACT(16),
    .WIDTH_TRIG_COUNT(16),
    .WIDTH_SAMPLES_COUNT(64),
    .WIDTH_ADC_CH(16)
  ) inst (
    .rx_cntr(rx_cntr),
    .adc_abs_max(adc_abs_max),
    .cur_adc(cur_adc),
    .last_detrigged(last_detrigged),
    .first_trgged(first_trgged),
    .adc_sent(adc_sent),
    .trigger_activated(trigger_activated),
    .triggers_count(triggers_count),
    .samples_count(samples_count),
    .cur_adc_a(cur_adc_a),
    .cur_adc_b(cur_adc_b),
    .sts_bus(sts_bus)
  );
endmodule
