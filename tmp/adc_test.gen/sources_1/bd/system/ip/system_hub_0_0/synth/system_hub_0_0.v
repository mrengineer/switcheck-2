// (c) Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// (c) Copyright 2022-2024 Advanced Micro Devices, Inc. All rights reserved.
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


// IP VLNV: pavel-demin:user:axi_hub:1.0
// IP Revision: 1

(* X_CORE_INFO = "axi_hub,Vivado 2023.2" *)
(* CHECK_LICENSE_TYPE = "system_hub_0_0,axi_hub,{}" *)
(* IP_DEFINITION_SOURCE = "package_project" *)
(* DowngradeIPIdentifiedWarnings = "yes" *)
module system_hub_0_0 (
  aclk,
  aresetn,
  s_axi_awid,
  s_axi_awaddr,
  s_axi_awvalid,
  s_axi_awready,
  s_axi_wstrb,
  s_axi_wlast,
  s_axi_wdata,
  s_axi_wvalid,
  s_axi_wready,
  s_axi_bid,
  s_axi_bvalid,
  s_axi_bready,
  s_axi_arid,
  s_axi_arlen,
  s_axi_araddr,
  s_axi_arvalid,
  s_axi_arready,
  s_axi_rid,
  s_axi_rlast,
  s_axi_rdata,
  s_axi_rvalid,
  s_axi_rready,
  cfg_data,
  sts_data,
  b00_bram_clk,
  b00_bram_rst,
  b00_bram_en,
  b00_bram_we,
  b00_bram_addr,
  b00_bram_wdata,
  b00_bram_rdata,
  s00_axis_tdata,
  s00_axis_tvalid,
  s00_axis_tready,
  m00_axis_tdata,
  m00_axis_tvalid,
  m00_axis_tready,
  b01_bram_clk,
  b01_bram_rst,
  b01_bram_en,
  b01_bram_we,
  b01_bram_addr,
  b01_bram_wdata,
  b01_bram_rdata,
  s01_axis_tdata,
  s01_axis_tvalid,
  s01_axis_tready,
  m01_axis_tdata,
  m01_axis_tvalid,
  m01_axis_tready,
  b02_bram_clk,
  b02_bram_rst,
  b02_bram_en,
  b02_bram_we,
  b02_bram_addr,
  b02_bram_wdata,
  b02_bram_rdata,
  s02_axis_tdata,
  s02_axis_tvalid,
  s02_axis_tready,
  m02_axis_tdata,
  m02_axis_tvalid,
  m02_axis_tready,
  b03_bram_clk,
  b03_bram_rst,
  b03_bram_en,
  b03_bram_we,
  b03_bram_addr,
  b03_bram_wdata,
  b03_bram_rdata,
  s03_axis_tdata,
  s03_axis_tvalid,
  s03_axis_tready,
  m03_axis_tdata,
  m03_axis_tvalid,
  m03_axis_tready,
  b04_bram_clk,
  b04_bram_rst,
  b04_bram_en,
  b04_bram_we,
  b04_bram_addr,
  b04_bram_wdata,
  b04_bram_rdata,
  s04_axis_tdata,
  s04_axis_tvalid,
  s04_axis_tready,
  m04_axis_tdata,
  m04_axis_tvalid,
  m04_axis_tready,
  b05_bram_clk,
  b05_bram_rst,
  b05_bram_en,
  b05_bram_we,
  b05_bram_addr,
  b05_bram_wdata,
  b05_bram_rdata,
  s05_axis_tdata,
  s05_axis_tvalid,
  s05_axis_tready,
  m05_axis_tdata,
  m05_axis_tvalid,
  m05_axis_tready
);

(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME aclk, ASSOCIATED_BUSIF m00_axis:m01_axis:m02_axis:m03_axis:m04_axis:m05_axis:s00_axis:s01_axis:s02_axis:s03_axis:s04_axis:s05_axis:s_axi, ASSOCIATED_RESET aresetn, FREQ_HZ 125000000, FREQ_TOLERANCE_HZ 0, PHASE 0.0, CLK_DOMAIN system_pll_0_0_clk_out1, INSERT_VIP 0" *)
(* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 aclk CLK" *)
input wire aclk;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME aresetn, POLARITY ACTIVE_LOW, INSERT_VIP 0" *)
(* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 aresetn RST" *)
input wire aresetn;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi AWID" *)
input wire [11 : 0] s_axi_awid;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi AWADDR" *)
input wire [31 : 0] s_axi_awaddr;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi AWVALID" *)
input wire s_axi_awvalid;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi AWREADY" *)
output wire s_axi_awready;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi WSTRB" *)
input wire [3 : 0] s_axi_wstrb;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi WLAST" *)
input wire s_axi_wlast;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi WDATA" *)
input wire [31 : 0] s_axi_wdata;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi WVALID" *)
input wire s_axi_wvalid;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi WREADY" *)
output wire s_axi_wready;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi BID" *)
output wire [11 : 0] s_axi_bid;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi BVALID" *)
output wire s_axi_bvalid;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi BREADY" *)
input wire s_axi_bready;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi ARID" *)
input wire [11 : 0] s_axi_arid;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi ARLEN" *)
input wire [3 : 0] s_axi_arlen;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi ARADDR" *)
input wire [31 : 0] s_axi_araddr;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi ARVALID" *)
input wire s_axi_arvalid;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi ARREADY" *)
output wire s_axi_arready;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi RID" *)
output wire [11 : 0] s_axi_rid;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi RLAST" *)
output wire s_axi_rlast;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi RDATA" *)
output wire [31 : 0] s_axi_rdata;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi RVALID" *)
output wire s_axi_rvalid;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME s_axi, DATA_WIDTH 32, PROTOCOL AXI3, FREQ_HZ 125000000, ID_WIDTH 12, ADDR_WIDTH 32, AWUSER_WIDTH 0, ARUSER_WIDTH 0, WUSER_WIDTH 0, RUSER_WIDTH 0, BUSER_WIDTH 0, READ_WRITE_MODE READ_WRITE, HAS_BURST 0, HAS_LOCK 0, HAS_PROT 0, HAS_CACHE 0, HAS_QOS 0, HAS_REGION 0, HAS_WSTRB 1, HAS_BRESP 0, HAS_RRESP 0, SUPPORTS_NARROW_BURST 0, NUM_READ_OUTSTANDING 2, NUM_WRITE_OUTSTANDING 2, MAX_BURST_LENGTH 16, PHASE 0.0, CLK_DOMAIN system_pll_0_0_clk_out1, NUM_READ_THREADS 4, NUM_WRITE_THREADS\
 4, RUSER_BITS_PER_BYTE 0, WUSER_BITS_PER_BYTE 0, INSERT_VIP 0" *)
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi RREADY" *)
input wire s_axi_rready;
output wire [159 : 0] cfg_data;
input wire [31 : 0] sts_data;
(* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 b00_bram CLK" *)
output wire b00_bram_clk;
(* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 b00_bram RST" *)
output wire b00_bram_rst;
(* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 b00_bram EN" *)
output wire b00_bram_en;
(* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 b00_bram WE" *)
output wire [3 : 0] b00_bram_we;
(* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 b00_bram ADDR" *)
output wire [21 : 0] b00_bram_addr;
(* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 b00_bram DIN" *)
output wire [31 : 0] b00_bram_wdata;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME b00_bram, MEM_SIZE 8192, MEM_WIDTH 32, MEM_ECC NONE, MASTER_TYPE OTHER, READ_LATENCY 1" *)
(* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 b00_bram DOUT" *)
input wire [31 : 0] b00_bram_rdata;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 s00_axis TDATA" *)
input wire [31 : 0] s00_axis_tdata;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 s00_axis TVALID" *)
input wire s00_axis_tvalid;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME s00_axis, TDATA_NUM_BYTES 4, TDEST_WIDTH 0, TID_WIDTH 0, TUSER_WIDTH 0, HAS_TREADY 1, HAS_TSTRB 0, HAS_TKEEP 0, HAS_TLAST 0, FREQ_HZ 125000000, PHASE 0.0, CLK_DOMAIN system_pll_0_0_clk_out1, LAYERED_METADATA undef, INSERT_VIP 0" *)
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 s00_axis TREADY" *)
output wire s00_axis_tready;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 m00_axis TDATA" *)
output wire [31 : 0] m00_axis_tdata;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 m00_axis TVALID" *)
output wire m00_axis_tvalid;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME m00_axis, TDATA_NUM_BYTES 4, TDEST_WIDTH 0, TID_WIDTH 0, TUSER_WIDTH 0, HAS_TREADY 1, HAS_TSTRB 0, HAS_TKEEP 0, HAS_TLAST 0, FREQ_HZ 125000000, PHASE 0.0, CLK_DOMAIN system_pll_0_0_clk_out1, LAYERED_METADATA undef, INSERT_VIP 0" *)
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 m00_axis TREADY" *)
input wire m00_axis_tready;
(* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 b01_bram CLK" *)
output wire b01_bram_clk;
(* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 b01_bram RST" *)
output wire b01_bram_rst;
(* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 b01_bram EN" *)
output wire b01_bram_en;
(* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 b01_bram WE" *)
output wire [3 : 0] b01_bram_we;
(* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 b01_bram ADDR" *)
output wire [21 : 0] b01_bram_addr;
(* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 b01_bram DIN" *)
output wire [31 : 0] b01_bram_wdata;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME b01_bram, MEM_SIZE 8192, MEM_WIDTH 32, MEM_ECC NONE, MASTER_TYPE OTHER, READ_LATENCY 1" *)
(* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 b01_bram DOUT" *)
input wire [31 : 0] b01_bram_rdata;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 s01_axis TDATA" *)
input wire [31 : 0] s01_axis_tdata;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 s01_axis TVALID" *)
input wire s01_axis_tvalid;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME s01_axis, TDATA_NUM_BYTES 4, TDEST_WIDTH 0, TID_WIDTH 0, TUSER_WIDTH 0, HAS_TREADY 1, HAS_TSTRB 0, HAS_TKEEP 0, HAS_TLAST 0, FREQ_HZ 125000000, PHASE 0.0, CLK_DOMAIN system_pll_0_0_clk_out1, LAYERED_METADATA undef, INSERT_VIP 0" *)
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 s01_axis TREADY" *)
output wire s01_axis_tready;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 m01_axis TDATA" *)
output wire [31 : 0] m01_axis_tdata;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 m01_axis TVALID" *)
output wire m01_axis_tvalid;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME m01_axis, TDATA_NUM_BYTES 4, TDEST_WIDTH 0, TID_WIDTH 0, TUSER_WIDTH 0, HAS_TREADY 1, HAS_TSTRB 0, HAS_TKEEP 0, HAS_TLAST 0, FREQ_HZ 125000000, PHASE 0.0, CLK_DOMAIN system_pll_0_0_clk_out1, LAYERED_METADATA undef, INSERT_VIP 0" *)
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 m01_axis TREADY" *)
input wire m01_axis_tready;
(* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 b02_bram CLK" *)
output wire b02_bram_clk;
(* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 b02_bram RST" *)
output wire b02_bram_rst;
(* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 b02_bram EN" *)
output wire b02_bram_en;
(* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 b02_bram WE" *)
output wire [3 : 0] b02_bram_we;
(* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 b02_bram ADDR" *)
output wire [21 : 0] b02_bram_addr;
(* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 b02_bram DIN" *)
output wire [31 : 0] b02_bram_wdata;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME b02_bram, MEM_SIZE 8192, MEM_WIDTH 32, MEM_ECC NONE, MASTER_TYPE OTHER, READ_LATENCY 1" *)
(* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 b02_bram DOUT" *)
input wire [31 : 0] b02_bram_rdata;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 s02_axis TDATA" *)
input wire [31 : 0] s02_axis_tdata;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 s02_axis TVALID" *)
input wire s02_axis_tvalid;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME s02_axis, TDATA_NUM_BYTES 4, TDEST_WIDTH 0, TID_WIDTH 0, TUSER_WIDTH 0, HAS_TREADY 1, HAS_TSTRB 0, HAS_TKEEP 0, HAS_TLAST 0, FREQ_HZ 125000000, PHASE 0.0, CLK_DOMAIN system_pll_0_0_clk_out1, LAYERED_METADATA undef, INSERT_VIP 0" *)
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 s02_axis TREADY" *)
output wire s02_axis_tready;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 m02_axis TDATA" *)
output wire [31 : 0] m02_axis_tdata;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 m02_axis TVALID" *)
output wire m02_axis_tvalid;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME m02_axis, TDATA_NUM_BYTES 4, TDEST_WIDTH 0, TID_WIDTH 0, TUSER_WIDTH 0, HAS_TREADY 1, HAS_TSTRB 0, HAS_TKEEP 0, HAS_TLAST 0, FREQ_HZ 125000000, PHASE 0.0, CLK_DOMAIN system_pll_0_0_clk_out1, LAYERED_METADATA undef, INSERT_VIP 0" *)
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 m02_axis TREADY" *)
input wire m02_axis_tready;
(* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 b03_bram CLK" *)
output wire b03_bram_clk;
(* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 b03_bram RST" *)
output wire b03_bram_rst;
(* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 b03_bram EN" *)
output wire b03_bram_en;
(* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 b03_bram WE" *)
output wire [3 : 0] b03_bram_we;
(* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 b03_bram ADDR" *)
output wire [21 : 0] b03_bram_addr;
(* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 b03_bram DIN" *)
output wire [31 : 0] b03_bram_wdata;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME b03_bram, MEM_SIZE 8192, MEM_WIDTH 32, MEM_ECC NONE, MASTER_TYPE OTHER, READ_LATENCY 1" *)
(* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 b03_bram DOUT" *)
input wire [31 : 0] b03_bram_rdata;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 s03_axis TDATA" *)
input wire [31 : 0] s03_axis_tdata;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 s03_axis TVALID" *)
input wire s03_axis_tvalid;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME s03_axis, TDATA_NUM_BYTES 4, TDEST_WIDTH 0, TID_WIDTH 0, TUSER_WIDTH 0, HAS_TREADY 1, HAS_TSTRB 0, HAS_TKEEP 0, HAS_TLAST 0, FREQ_HZ 125000000, PHASE 0.0, CLK_DOMAIN system_pll_0_0_clk_out1, LAYERED_METADATA undef, INSERT_VIP 0" *)
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 s03_axis TREADY" *)
output wire s03_axis_tready;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 m03_axis TDATA" *)
output wire [31 : 0] m03_axis_tdata;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 m03_axis TVALID" *)
output wire m03_axis_tvalid;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME m03_axis, TDATA_NUM_BYTES 4, TDEST_WIDTH 0, TID_WIDTH 0, TUSER_WIDTH 0, HAS_TREADY 1, HAS_TSTRB 0, HAS_TKEEP 0, HAS_TLAST 0, FREQ_HZ 125000000, PHASE 0.0, CLK_DOMAIN system_pll_0_0_clk_out1, LAYERED_METADATA undef, INSERT_VIP 0" *)
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 m03_axis TREADY" *)
input wire m03_axis_tready;
(* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 b04_bram CLK" *)
output wire b04_bram_clk;
(* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 b04_bram RST" *)
output wire b04_bram_rst;
(* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 b04_bram EN" *)
output wire b04_bram_en;
(* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 b04_bram WE" *)
output wire [3 : 0] b04_bram_we;
(* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 b04_bram ADDR" *)
output wire [21 : 0] b04_bram_addr;
(* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 b04_bram DIN" *)
output wire [31 : 0] b04_bram_wdata;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME b04_bram, MEM_SIZE 8192, MEM_WIDTH 32, MEM_ECC NONE, MASTER_TYPE OTHER, READ_LATENCY 1" *)
(* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 b04_bram DOUT" *)
input wire [31 : 0] b04_bram_rdata;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 s04_axis TDATA" *)
input wire [31 : 0] s04_axis_tdata;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 s04_axis TVALID" *)
input wire s04_axis_tvalid;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME s04_axis, TDATA_NUM_BYTES 4, TDEST_WIDTH 0, TID_WIDTH 0, TUSER_WIDTH 0, HAS_TREADY 1, HAS_TSTRB 0, HAS_TKEEP 0, HAS_TLAST 0, FREQ_HZ 125000000, PHASE 0.0, CLK_DOMAIN system_pll_0_0_clk_out1, LAYERED_METADATA undef, INSERT_VIP 0" *)
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 s04_axis TREADY" *)
output wire s04_axis_tready;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 m04_axis TDATA" *)
output wire [31 : 0] m04_axis_tdata;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 m04_axis TVALID" *)
output wire m04_axis_tvalid;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME m04_axis, TDATA_NUM_BYTES 4, TDEST_WIDTH 0, TID_WIDTH 0, TUSER_WIDTH 0, HAS_TREADY 1, HAS_TSTRB 0, HAS_TKEEP 0, HAS_TLAST 0, FREQ_HZ 125000000, PHASE 0.0, CLK_DOMAIN system_pll_0_0_clk_out1, LAYERED_METADATA undef, INSERT_VIP 0" *)
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 m04_axis TREADY" *)
input wire m04_axis_tready;
(* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 b05_bram CLK" *)
output wire b05_bram_clk;
(* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 b05_bram RST" *)
output wire b05_bram_rst;
(* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 b05_bram EN" *)
output wire b05_bram_en;
(* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 b05_bram WE" *)
output wire [3 : 0] b05_bram_we;
(* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 b05_bram ADDR" *)
output wire [21 : 0] b05_bram_addr;
(* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 b05_bram DIN" *)
output wire [31 : 0] b05_bram_wdata;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME b05_bram, MEM_SIZE 8192, MEM_WIDTH 32, MEM_ECC NONE, MASTER_TYPE OTHER, READ_LATENCY 1" *)
(* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 b05_bram DOUT" *)
input wire [31 : 0] b05_bram_rdata;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 s05_axis TDATA" *)
input wire [31 : 0] s05_axis_tdata;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 s05_axis TVALID" *)
input wire s05_axis_tvalid;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME s05_axis, TDATA_NUM_BYTES 4, TDEST_WIDTH 0, TID_WIDTH 0, TUSER_WIDTH 0, HAS_TREADY 1, HAS_TSTRB 0, HAS_TKEEP 0, HAS_TLAST 0, FREQ_HZ 125000000, PHASE 0.0, CLK_DOMAIN system_pll_0_0_clk_out1, LAYERED_METADATA undef, INSERT_VIP 0" *)
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 s05_axis TREADY" *)
output wire s05_axis_tready;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 m05_axis TDATA" *)
output wire [31 : 0] m05_axis_tdata;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 m05_axis TVALID" *)
output wire m05_axis_tvalid;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME m05_axis, TDATA_NUM_BYTES 4, TDEST_WIDTH 0, TID_WIDTH 0, TUSER_WIDTH 0, HAS_TREADY 1, HAS_TSTRB 0, HAS_TKEEP 0, HAS_TLAST 0, FREQ_HZ 125000000, PHASE 0.0, CLK_DOMAIN system_pll_0_0_clk_out1, LAYERED_METADATA undef, INSERT_VIP 0" *)
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 m05_axis TREADY" *)
input wire m05_axis_tready;

  axi_hub #(
    .CFG_DATA_WIDTH(160),
    .STS_DATA_WIDTH(32)
  ) inst (
    .aclk(aclk),
    .aresetn(aresetn),
    .s_axi_awid(s_axi_awid),
    .s_axi_awaddr(s_axi_awaddr),
    .s_axi_awvalid(s_axi_awvalid),
    .s_axi_awready(s_axi_awready),
    .s_axi_wstrb(s_axi_wstrb),
    .s_axi_wlast(s_axi_wlast),
    .s_axi_wdata(s_axi_wdata),
    .s_axi_wvalid(s_axi_wvalid),
    .s_axi_wready(s_axi_wready),
    .s_axi_bid(s_axi_bid),
    .s_axi_bvalid(s_axi_bvalid),
    .s_axi_bready(s_axi_bready),
    .s_axi_arid(s_axi_arid),
    .s_axi_arlen(s_axi_arlen),
    .s_axi_araddr(s_axi_araddr),
    .s_axi_arvalid(s_axi_arvalid),
    .s_axi_arready(s_axi_arready),
    .s_axi_rid(s_axi_rid),
    .s_axi_rlast(s_axi_rlast),
    .s_axi_rdata(s_axi_rdata),
    .s_axi_rvalid(s_axi_rvalid),
    .s_axi_rready(s_axi_rready),
    .cfg_data(cfg_data),
    .sts_data(sts_data),
    .b00_bram_clk(b00_bram_clk),
    .b00_bram_rst(b00_bram_rst),
    .b00_bram_en(b00_bram_en),
    .b00_bram_we(b00_bram_we),
    .b00_bram_addr(b00_bram_addr),
    .b00_bram_wdata(b00_bram_wdata),
    .b00_bram_rdata(b00_bram_rdata),
    .s00_axis_tdata(s00_axis_tdata),
    .s00_axis_tvalid(s00_axis_tvalid),
    .s00_axis_tready(s00_axis_tready),
    .m00_axis_tdata(m00_axis_tdata),
    .m00_axis_tvalid(m00_axis_tvalid),
    .m00_axis_tready(m00_axis_tready),
    .b01_bram_clk(b01_bram_clk),
    .b01_bram_rst(b01_bram_rst),
    .b01_bram_en(b01_bram_en),
    .b01_bram_we(b01_bram_we),
    .b01_bram_addr(b01_bram_addr),
    .b01_bram_wdata(b01_bram_wdata),
    .b01_bram_rdata(b01_bram_rdata),
    .s01_axis_tdata(s01_axis_tdata),
    .s01_axis_tvalid(s01_axis_tvalid),
    .s01_axis_tready(s01_axis_tready),
    .m01_axis_tdata(m01_axis_tdata),
    .m01_axis_tvalid(m01_axis_tvalid),
    .m01_axis_tready(m01_axis_tready),
    .b02_bram_clk(b02_bram_clk),
    .b02_bram_rst(b02_bram_rst),
    .b02_bram_en(b02_bram_en),
    .b02_bram_we(b02_bram_we),
    .b02_bram_addr(b02_bram_addr),
    .b02_bram_wdata(b02_bram_wdata),
    .b02_bram_rdata(b02_bram_rdata),
    .s02_axis_tdata(s02_axis_tdata),
    .s02_axis_tvalid(s02_axis_tvalid),
    .s02_axis_tready(s02_axis_tready),
    .m02_axis_tdata(m02_axis_tdata),
    .m02_axis_tvalid(m02_axis_tvalid),
    .m02_axis_tready(m02_axis_tready),
    .b03_bram_clk(b03_bram_clk),
    .b03_bram_rst(b03_bram_rst),
    .b03_bram_en(b03_bram_en),
    .b03_bram_we(b03_bram_we),
    .b03_bram_addr(b03_bram_addr),
    .b03_bram_wdata(b03_bram_wdata),
    .b03_bram_rdata(b03_bram_rdata),
    .s03_axis_tdata(s03_axis_tdata),
    .s03_axis_tvalid(s03_axis_tvalid),
    .s03_axis_tready(s03_axis_tready),
    .m03_axis_tdata(m03_axis_tdata),
    .m03_axis_tvalid(m03_axis_tvalid),
    .m03_axis_tready(m03_axis_tready),
    .b04_bram_clk(b04_bram_clk),
    .b04_bram_rst(b04_bram_rst),
    .b04_bram_en(b04_bram_en),
    .b04_bram_we(b04_bram_we),
    .b04_bram_addr(b04_bram_addr),
    .b04_bram_wdata(b04_bram_wdata),
    .b04_bram_rdata(b04_bram_rdata),
    .s04_axis_tdata(s04_axis_tdata),
    .s04_axis_tvalid(s04_axis_tvalid),
    .s04_axis_tready(s04_axis_tready),
    .m04_axis_tdata(m04_axis_tdata),
    .m04_axis_tvalid(m04_axis_tvalid),
    .m04_axis_tready(m04_axis_tready),
    .b05_bram_clk(b05_bram_clk),
    .b05_bram_rst(b05_bram_rst),
    .b05_bram_en(b05_bram_en),
    .b05_bram_we(b05_bram_we),
    .b05_bram_addr(b05_bram_addr),
    .b05_bram_wdata(b05_bram_wdata),
    .b05_bram_rdata(b05_bram_rdata),
    .s05_axis_tdata(s05_axis_tdata),
    .s05_axis_tvalid(s05_axis_tvalid),
    .s05_axis_tready(s05_axis_tready),
    .m05_axis_tdata(m05_axis_tdata),
    .m05_axis_tvalid(m05_axis_tvalid),
    .m05_axis_tready(m05_axis_tready)
  );
endmodule
