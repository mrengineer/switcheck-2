//Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
//Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2023.2 (lin64) Build 4029153 Fri Oct 13 20:13:54 MDT 2023
//Date        : Wed Oct 23 22:42:57 2024
//Host        : bigbc running 64-bit Ubuntu 24.04 LTS
//Command     : generate_target system.bd
//Design      : system
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CORE_GENERATION_INFO = "system,IP_Integrator,{x_ipVendor=xilinx.com,x_ipLibrary=BlockDiagram,x_ipName=system,x_ipVersion=1.00.a,x_ipLanguage=VERILOG,numBlks=21,numReposBlks=21,numNonXlnxBlks=9,numHierBlks=0,maxHierDepth=0,numSysgenBlks=0,numHlsBlks=0,numHdlrefBlks=0,numPkgbdBlks=0,bdsource=USER,da_ps7_cnt=1,synth_mode=None}" *) (* HW_HANDOFF = "system.hwdef" *) 
module system
   (DDR_addr,
    DDR_ba,
    DDR_cas_n,
    DDR_ck_n,
    DDR_ck_p,
    DDR_cke,
    DDR_cs_n,
    DDR_dm,
    DDR_dq,
    DDR_dqs_n,
    DDR_dqs_p,
    DDR_odt,
    DDR_ras_n,
    DDR_reset_n,
    DDR_we_n,
    FIXED_IO_ddr_vrn,
    FIXED_IO_ddr_vrp,
    FIXED_IO_mio,
    FIXED_IO_ps_clk,
    FIXED_IO_ps_porb,
    FIXED_IO_ps_srstb,
    adc_clk_n_i,
    adc_clk_p_i,
    adc_csn_o,
    adc_dat_a_i,
    adc_dat_b_i,
    adc_enc_n_o,
    adc_enc_p_o,
    dac_clk_o,
    dac_dat_o,
    dac_pwm_o,
    dac_rst_o,
    dac_sel_o,
    dac_wrt_o,
    exp_n_tri_io,
    exp_p_tri_io,
    led_o);
  (* X_INTERFACE_INFO = "xilinx.com:interface:ddrx:1.0 DDR ADDR" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME DDR, AXI_ARBITRATION_SCHEME TDM, BURST_LENGTH 8, CAN_DEBUG false, CAS_LATENCY 11, CAS_WRITE_LATENCY 11, CS_ENABLED true, DATA_MASK_ENABLED true, DATA_WIDTH 8, MEMORY_TYPE COMPONENTS, MEM_ADDR_MAP ROW_COLUMN_BANK, SLOT Single, TIMEPERIOD_PS 1250" *) inout [14:0]DDR_addr;
  (* X_INTERFACE_INFO = "xilinx.com:interface:ddrx:1.0 DDR BA" *) inout [2:0]DDR_ba;
  (* X_INTERFACE_INFO = "xilinx.com:interface:ddrx:1.0 DDR CAS_N" *) inout DDR_cas_n;
  (* X_INTERFACE_INFO = "xilinx.com:interface:ddrx:1.0 DDR CK_N" *) inout DDR_ck_n;
  (* X_INTERFACE_INFO = "xilinx.com:interface:ddrx:1.0 DDR CK_P" *) inout DDR_ck_p;
  (* X_INTERFACE_INFO = "xilinx.com:interface:ddrx:1.0 DDR CKE" *) inout DDR_cke;
  (* X_INTERFACE_INFO = "xilinx.com:interface:ddrx:1.0 DDR CS_N" *) inout DDR_cs_n;
  (* X_INTERFACE_INFO = "xilinx.com:interface:ddrx:1.0 DDR DM" *) inout [3:0]DDR_dm;
  (* X_INTERFACE_INFO = "xilinx.com:interface:ddrx:1.0 DDR DQ" *) inout [31:0]DDR_dq;
  (* X_INTERFACE_INFO = "xilinx.com:interface:ddrx:1.0 DDR DQS_N" *) inout [3:0]DDR_dqs_n;
  (* X_INTERFACE_INFO = "xilinx.com:interface:ddrx:1.0 DDR DQS_P" *) inout [3:0]DDR_dqs_p;
  (* X_INTERFACE_INFO = "xilinx.com:interface:ddrx:1.0 DDR ODT" *) inout DDR_odt;
  (* X_INTERFACE_INFO = "xilinx.com:interface:ddrx:1.0 DDR RAS_N" *) inout DDR_ras_n;
  (* X_INTERFACE_INFO = "xilinx.com:interface:ddrx:1.0 DDR RESET_N" *) inout DDR_reset_n;
  (* X_INTERFACE_INFO = "xilinx.com:interface:ddrx:1.0 DDR WE_N" *) inout DDR_we_n;
  (* X_INTERFACE_INFO = "xilinx.com:display_processing_system7:fixedio:1.0 FIXED_IO DDR_VRN" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME FIXED_IO, CAN_DEBUG false" *) inout FIXED_IO_ddr_vrn;
  (* X_INTERFACE_INFO = "xilinx.com:display_processing_system7:fixedio:1.0 FIXED_IO DDR_VRP" *) inout FIXED_IO_ddr_vrp;
  (* X_INTERFACE_INFO = "xilinx.com:display_processing_system7:fixedio:1.0 FIXED_IO MIO" *) inout [53:0]FIXED_IO_mio;
  (* X_INTERFACE_INFO = "xilinx.com:display_processing_system7:fixedio:1.0 FIXED_IO PS_CLK" *) inout FIXED_IO_ps_clk;
  (* X_INTERFACE_INFO = "xilinx.com:display_processing_system7:fixedio:1.0 FIXED_IO PS_PORB" *) inout FIXED_IO_ps_porb;
  (* X_INTERFACE_INFO = "xilinx.com:display_processing_system7:fixedio:1.0 FIXED_IO PS_SRSTB" *) inout FIXED_IO_ps_srstb;
  input adc_clk_n_i;
  input adc_clk_p_i;
  output adc_csn_o;
  input [15:0]adc_dat_a_i;
  input [15:0]adc_dat_b_i;
  output adc_enc_n_o;
  output adc_enc_p_o;
  output dac_clk_o;
  output [13:0]dac_dat_o;
  output [3:0]dac_pwm_o;
  output dac_rst_o;
  output dac_sel_o;
  output dac_wrt_o;
  inout [7:0]exp_n_tri_io;
  output [7:0]exp_p_tri_io;
  output [7:0]led_o;

  wire adc_0_adc_csn;
  wire [31:0]adc_0_m_axis_TDATA;
  wire adc_0_m_axis_TVALID;
  wire adc_clk_n_i_1;
  wire adc_clk_p_i_1;
  wire [15:0]adc_dat_a_i_1;
  wire [15:0]adc_dat_b_i_1;
  wire [15:0]bcast_0_M00_AXIS_TDATA;
  wire [0:0]bcast_0_M00_AXIS_TVALID;
  wire [31:16]bcast_0_M01_AXIS_TDATA;
  wire [1:1]bcast_0_M01_AXIS_TVALID;
  wire [15:0]cic_0_M_AXIS_DATA_TDATA;
  wire cic_0_M_AXIS_DATA_TVALID;
  wire [15:0]cic_1_M_AXIS_DATA_TDATA;
  wire cic_1_M_AXIS_DATA_TVALID;
  wire [31:0]comb_0_M_AXIS_TDATA;
  wire comb_0_M_AXIS_TREADY;
  wire comb_0_M_AXIS_TVALID;
  wire [7:0]concat_0_dout;
  wire [0:0]const_0_dout;
  wire [17:0]const_1_dout;
  wire [31:0]fir_0_M_AXIS_DATA_TDATA;
  wire fir_0_M_AXIS_DATA_TREADY;
  wire fir_0_M_AXIS_DATA_TVALID;
  wire [95:0]hub_0_cfg_data;
  wire [0:0]not_0_Res;
  wire [31:0]pktzr_0_m_axis_TDATA;
  wire pktzr_0_m_axis_TREADY;
  wire pktzr_0_m_axis_TVALID;
  wire pll_0_clk_out1;
  wire pll_0_locked;
  wire [14:0]ps_0_DDR_ADDR;
  wire [2:0]ps_0_DDR_BA;
  wire ps_0_DDR_CAS_N;
  wire ps_0_DDR_CKE;
  wire ps_0_DDR_CK_N;
  wire ps_0_DDR_CK_P;
  wire ps_0_DDR_CS_N;
  wire [3:0]ps_0_DDR_DM;
  wire [31:0]ps_0_DDR_DQ;
  wire [3:0]ps_0_DDR_DQS_N;
  wire [3:0]ps_0_DDR_DQS_P;
  wire ps_0_DDR_ODT;
  wire ps_0_DDR_RAS_N;
  wire ps_0_DDR_RESET_N;
  wire ps_0_DDR_WE_N;
  wire ps_0_FIXED_IO_DDR_VRN;
  wire ps_0_FIXED_IO_DDR_VRP;
  wire [53:0]ps_0_FIXED_IO_MIO;
  wire ps_0_FIXED_IO_PS_CLK;
  wire ps_0_FIXED_IO_PS_PORB;
  wire ps_0_FIXED_IO_PS_SRSTB;
  wire [31:0]ps_0_M_AXI_GP0_ARADDR;
  wire [11:0]ps_0_M_AXI_GP0_ARID;
  wire [3:0]ps_0_M_AXI_GP0_ARLEN;
  wire ps_0_M_AXI_GP0_ARREADY;
  wire ps_0_M_AXI_GP0_ARVALID;
  wire [31:0]ps_0_M_AXI_GP0_AWADDR;
  wire [11:0]ps_0_M_AXI_GP0_AWID;
  wire ps_0_M_AXI_GP0_AWREADY;
  wire ps_0_M_AXI_GP0_AWVALID;
  wire [11:0]ps_0_M_AXI_GP0_BID;
  wire ps_0_M_AXI_GP0_BREADY;
  wire ps_0_M_AXI_GP0_BVALID;
  wire [31:0]ps_0_M_AXI_GP0_RDATA;
  wire [11:0]ps_0_M_AXI_GP0_RID;
  wire ps_0_M_AXI_GP0_RLAST;
  wire ps_0_M_AXI_GP0_RREADY;
  wire ps_0_M_AXI_GP0_RVALID;
  wire [31:0]ps_0_M_AXI_GP0_WDATA;
  wire ps_0_M_AXI_GP0_WLAST;
  wire ps_0_M_AXI_GP0_WREADY;
  wire [3:0]ps_0_M_AXI_GP0_WSTRB;
  wire ps_0_M_AXI_GP0_WVALID;
  wire [0:0]rst_0_peripheral_aresetn;
  wire [0:0]slice_0_dout;
  wire [0:0]slice_1_dout;
  wire [0:0]slice_2_dout;
  wire [31:0]slice_3_dout;
  wire [31:0]slice_4_dout;
  wire [31:0]writer_0_m_axi_AWADDR;
  wire [1:0]writer_0_m_axi_AWBURST;
  wire [3:0]writer_0_m_axi_AWCACHE;
  wire [2:0]writer_0_m_axi_AWID;
  wire [3:0]writer_0_m_axi_AWLEN;
  wire writer_0_m_axi_AWREADY;
  wire [2:0]writer_0_m_axi_AWSIZE;
  wire writer_0_m_axi_AWVALID;
  wire writer_0_m_axi_BREADY;
  wire writer_0_m_axi_BVALID;
  wire [63:0]writer_0_m_axi_WDATA;
  wire [2:0]writer_0_m_axi_WID;
  wire writer_0_m_axi_WLAST;
  wire writer_0_m_axi_WREADY;
  wire [7:0]writer_0_m_axi_WSTRB;
  wire writer_0_m_axi_WVALID;

  assign adc_clk_n_i_1 = adc_clk_n_i;
  assign adc_clk_p_i_1 = adc_clk_p_i;
  assign adc_csn_o = adc_0_adc_csn;
  assign adc_dat_a_i_1 = adc_dat_a_i[15:0];
  assign adc_dat_b_i_1 = adc_dat_b_i[15:0];
  assign exp_p_tri_io[7:0] = concat_0_dout;
  system_adc_0_0 adc_0
       (.aclk(pll_0_clk_out1),
        .adc_csn(adc_0_adc_csn),
        .adc_dat_a(adc_dat_a_i_1),
        .adc_dat_b(adc_dat_b_i_1),
        .m_axis_tdata(adc_0_m_axis_TDATA),
        .m_axis_tvalid(adc_0_m_axis_TVALID));
  system_bcast_0_0 bcast_0
       (.aclk(pll_0_clk_out1),
        .aresetn(slice_0_dout),
        .m_axis_tdata({bcast_0_M01_AXIS_TDATA,bcast_0_M00_AXIS_TDATA}),
        .m_axis_tvalid({bcast_0_M01_AXIS_TVALID,bcast_0_M00_AXIS_TVALID}),
        .s_axis_tdata(adc_0_m_axis_TDATA),
        .s_axis_tvalid(adc_0_m_axis_TVALID));
  system_cic_0_0 cic_0
       (.aclk(pll_0_clk_out1),
        .aresetn(slice_0_dout),
        .m_axis_data_tdata(cic_0_M_AXIS_DATA_TDATA),
        .m_axis_data_tvalid(cic_0_M_AXIS_DATA_TVALID),
        .s_axis_data_tdata(bcast_0_M00_AXIS_TDATA),
        .s_axis_data_tvalid(bcast_0_M00_AXIS_TVALID));
  system_cic_1_0 cic_1
       (.aclk(pll_0_clk_out1),
        .aresetn(slice_0_dout),
        .m_axis_data_tdata(cic_1_M_AXIS_DATA_TDATA),
        .m_axis_data_tvalid(cic_1_M_AXIS_DATA_TVALID),
        .s_axis_data_tdata(bcast_0_M01_AXIS_TDATA),
        .s_axis_data_tvalid(bcast_0_M01_AXIS_TVALID));
  system_comb_0_0 comb_0
       (.aclk(pll_0_clk_out1),
        .aresetn(slice_0_dout),
        .m_axis_tdata(comb_0_M_AXIS_TDATA),
        .m_axis_tready(comb_0_M_AXIS_TREADY),
        .m_axis_tvalid(comb_0_M_AXIS_TVALID),
        .s_axis_tdata({cic_1_M_AXIS_DATA_TDATA,cic_0_M_AXIS_DATA_TDATA}),
        .s_axis_tvalid({cic_1_M_AXIS_DATA_TVALID,cic_0_M_AXIS_DATA_TVALID}));
  system_concat_0_0 concat_0
       (.In0(not_0_Res),
        .In1({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .dout(concat_0_dout));
  system_const_0_0 const_0
       (.dout(const_0_dout));
  system_const_1_0 const_1
       (.dout(const_1_dout));
  system_fir_0_0 fir_0
       (.aclk(pll_0_clk_out1),
        .aresetn(slice_0_dout),
        .m_axis_data_tdata(fir_0_M_AXIS_DATA_TDATA),
        .m_axis_data_tready(fir_0_M_AXIS_DATA_TREADY),
        .m_axis_data_tvalid(fir_0_M_AXIS_DATA_TVALID),
        .s_axis_data_tdata(comb_0_M_AXIS_TDATA),
        .s_axis_data_tready(comb_0_M_AXIS_TREADY),
        .s_axis_data_tvalid(comb_0_M_AXIS_TVALID));
  system_hub_0_0 hub_0
       (.aclk(pll_0_clk_out1),
        .aresetn(rst_0_peripheral_aresetn),
        .b00_bram_rdata({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b1,1'b0,1'b0,1'b0}),
        .b01_bram_rdata({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b1,1'b0,1'b0,1'b0}),
        .b02_bram_rdata({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b1,1'b0,1'b0,1'b0}),
        .b03_bram_rdata({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b1,1'b0,1'b0,1'b0}),
        .b04_bram_rdata({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b1,1'b0,1'b0,1'b0}),
        .b05_bram_rdata({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b1,1'b0,1'b0,1'b0}),
        .cfg_data(hub_0_cfg_data),
        .m00_axis_tready(1'b1),
        .m01_axis_tready(1'b1),
        .m02_axis_tready(1'b1),
        .m03_axis_tready(1'b1),
        .m04_axis_tready(1'b1),
        .m05_axis_tready(1'b1),
        .s00_axis_tdata({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s00_axis_tvalid(1'b0),
        .s01_axis_tdata({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s01_axis_tvalid(1'b0),
        .s02_axis_tdata({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s02_axis_tvalid(1'b0),
        .s03_axis_tdata({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s03_axis_tvalid(1'b0),
        .s04_axis_tdata({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s04_axis_tvalid(1'b0),
        .s05_axis_tdata({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s05_axis_tvalid(1'b0),
        .s_axi_araddr(ps_0_M_AXI_GP0_ARADDR),
        .s_axi_arid(ps_0_M_AXI_GP0_ARID),
        .s_axi_arlen(ps_0_M_AXI_GP0_ARLEN),
        .s_axi_arready(ps_0_M_AXI_GP0_ARREADY),
        .s_axi_arvalid(ps_0_M_AXI_GP0_ARVALID),
        .s_axi_awaddr(ps_0_M_AXI_GP0_AWADDR),
        .s_axi_awid(ps_0_M_AXI_GP0_AWID),
        .s_axi_awready(ps_0_M_AXI_GP0_AWREADY),
        .s_axi_awvalid(ps_0_M_AXI_GP0_AWVALID),
        .s_axi_bid(ps_0_M_AXI_GP0_BID),
        .s_axi_bready(ps_0_M_AXI_GP0_BREADY),
        .s_axi_bvalid(ps_0_M_AXI_GP0_BVALID),
        .s_axi_rdata(ps_0_M_AXI_GP0_RDATA),
        .s_axi_rid(ps_0_M_AXI_GP0_RID),
        .s_axi_rlast(ps_0_M_AXI_GP0_RLAST),
        .s_axi_rready(ps_0_M_AXI_GP0_RREADY),
        .s_axi_rvalid(ps_0_M_AXI_GP0_RVALID),
        .s_axi_wdata(ps_0_M_AXI_GP0_WDATA),
        .s_axi_wlast(ps_0_M_AXI_GP0_WLAST),
        .s_axi_wready(ps_0_M_AXI_GP0_WREADY),
        .s_axi_wstrb(ps_0_M_AXI_GP0_WSTRB),
        .s_axi_wvalid(ps_0_M_AXI_GP0_WVALID),
        .sts_data({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}));
  system_not_0_0 not_0
       (.Op1(slice_1_dout),
        .Res(not_0_Res));
  system_pktzr_0_0 pktzr_0
       (.aclk(pll_0_clk_out1),
        .aresetn(slice_1_dout),
        .cfg_data(slice_4_dout),
        .m_axis_tdata(pktzr_0_m_axis_TDATA),
        .m_axis_tready(pktzr_0_m_axis_TREADY),
        .m_axis_tvalid(pktzr_0_m_axis_TVALID),
        .s_axis_tdata(fir_0_M_AXIS_DATA_TDATA),
        .s_axis_tready(fir_0_M_AXIS_DATA_TREADY),
        .s_axis_tvalid(fir_0_M_AXIS_DATA_TVALID));
  system_pll_0_0 pll_0
       (.clk_in1_n(adc_clk_n_i_1),
        .clk_in1_p(adc_clk_p_i_1),
        .clk_out1(pll_0_clk_out1),
        .locked(pll_0_locked));
  system_ps_0_0 ps_0
       (.DDR_Addr(DDR_addr[14:0]),
        .DDR_BankAddr(DDR_ba[2:0]),
        .DDR_CAS_n(DDR_cas_n),
        .DDR_CKE(DDR_cke),
        .DDR_CS_n(DDR_cs_n),
        .DDR_Clk(DDR_ck_p),
        .DDR_Clk_n(DDR_ck_n),
        .DDR_DM(DDR_dm[3:0]),
        .DDR_DQ(DDR_dq[31:0]),
        .DDR_DQS(DDR_dqs_p[3:0]),
        .DDR_DQS_n(DDR_dqs_n[3:0]),
        .DDR_DRSTB(DDR_reset_n),
        .DDR_ODT(DDR_odt),
        .DDR_RAS_n(DDR_ras_n),
        .DDR_VRN(FIXED_IO_ddr_vrn),
        .DDR_VRP(FIXED_IO_ddr_vrp),
        .DDR_WEB(DDR_we_n),
        .GPIO_I({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .MIO(FIXED_IO_mio[53:0]),
        .M_AXI_GP0_ACLK(pll_0_clk_out1),
        .M_AXI_GP0_ARADDR(ps_0_M_AXI_GP0_ARADDR),
        .M_AXI_GP0_ARID(ps_0_M_AXI_GP0_ARID),
        .M_AXI_GP0_ARLEN(ps_0_M_AXI_GP0_ARLEN),
        .M_AXI_GP0_ARREADY(ps_0_M_AXI_GP0_ARREADY),
        .M_AXI_GP0_ARVALID(ps_0_M_AXI_GP0_ARVALID),
        .M_AXI_GP0_AWADDR(ps_0_M_AXI_GP0_AWADDR),
        .M_AXI_GP0_AWID(ps_0_M_AXI_GP0_AWID),
        .M_AXI_GP0_AWREADY(ps_0_M_AXI_GP0_AWREADY),
        .M_AXI_GP0_AWVALID(ps_0_M_AXI_GP0_AWVALID),
        .M_AXI_GP0_BID(ps_0_M_AXI_GP0_BID),
        .M_AXI_GP0_BREADY(ps_0_M_AXI_GP0_BREADY),
        .M_AXI_GP0_BRESP({1'b0,1'b0}),
        .M_AXI_GP0_BVALID(ps_0_M_AXI_GP0_BVALID),
        .M_AXI_GP0_RDATA(ps_0_M_AXI_GP0_RDATA),
        .M_AXI_GP0_RID(ps_0_M_AXI_GP0_RID),
        .M_AXI_GP0_RLAST(ps_0_M_AXI_GP0_RLAST),
        .M_AXI_GP0_RREADY(ps_0_M_AXI_GP0_RREADY),
        .M_AXI_GP0_RRESP({1'b0,1'b0}),
        .M_AXI_GP0_RVALID(ps_0_M_AXI_GP0_RVALID),
        .M_AXI_GP0_WDATA(ps_0_M_AXI_GP0_WDATA),
        .M_AXI_GP0_WLAST(ps_0_M_AXI_GP0_WLAST),
        .M_AXI_GP0_WREADY(ps_0_M_AXI_GP0_WREADY),
        .M_AXI_GP0_WSTRB(ps_0_M_AXI_GP0_WSTRB),
        .M_AXI_GP0_WVALID(ps_0_M_AXI_GP0_WVALID),
        .PS_CLK(FIXED_IO_ps_clk),
        .PS_PORB(FIXED_IO_ps_porb),
        .PS_SRSTB(FIXED_IO_ps_srstb),
        .SPI0_MISO_I(1'b0),
        .SPI0_MOSI_I(1'b0),
        .SPI0_SCLK_I(1'b0),
        .SPI0_SS_I(1'b0),
        .S_AXI_ACP_ACLK(pll_0_clk_out1),
        .S_AXI_ACP_ARADDR({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .S_AXI_ACP_ARBURST({1'b0,1'b1}),
        .S_AXI_ACP_ARCACHE({1'b0,1'b0,1'b1,1'b1}),
        .S_AXI_ACP_ARID({1'b0,1'b0,1'b0}),
        .S_AXI_ACP_ARLEN({1'b0,1'b0,1'b0,1'b0}),
        .S_AXI_ACP_ARLOCK({1'b0,1'b0}),
        .S_AXI_ACP_ARPROT({1'b0,1'b0,1'b0}),
        .S_AXI_ACP_ARQOS({1'b0,1'b0,1'b0,1'b0}),
        .S_AXI_ACP_ARSIZE({1'b0,1'b1,1'b1}),
        .S_AXI_ACP_ARUSER({1'b0,1'b0,1'b0,1'b0,1'b0}),
        .S_AXI_ACP_ARVALID(1'b0),
        .S_AXI_ACP_AWADDR(writer_0_m_axi_AWADDR),
        .S_AXI_ACP_AWBURST(writer_0_m_axi_AWBURST),
        .S_AXI_ACP_AWCACHE(writer_0_m_axi_AWCACHE),
        .S_AXI_ACP_AWID(writer_0_m_axi_AWID),
        .S_AXI_ACP_AWLEN(writer_0_m_axi_AWLEN),
        .S_AXI_ACP_AWLOCK({1'b0,1'b0}),
        .S_AXI_ACP_AWPROT({1'b0,1'b0,1'b0}),
        .S_AXI_ACP_AWQOS({1'b0,1'b0,1'b0,1'b0}),
        .S_AXI_ACP_AWREADY(writer_0_m_axi_AWREADY),
        .S_AXI_ACP_AWSIZE(writer_0_m_axi_AWSIZE),
        .S_AXI_ACP_AWUSER({1'b0,1'b0,1'b0,1'b0,1'b0}),
        .S_AXI_ACP_AWVALID(writer_0_m_axi_AWVALID),
        .S_AXI_ACP_BREADY(writer_0_m_axi_BREADY),
        .S_AXI_ACP_BVALID(writer_0_m_axi_BVALID),
        .S_AXI_ACP_RREADY(1'b0),
        .S_AXI_ACP_WDATA(writer_0_m_axi_WDATA),
        .S_AXI_ACP_WID(writer_0_m_axi_WID),
        .S_AXI_ACP_WLAST(writer_0_m_axi_WLAST),
        .S_AXI_ACP_WREADY(writer_0_m_axi_WREADY),
        .S_AXI_ACP_WSTRB(writer_0_m_axi_WSTRB),
        .S_AXI_ACP_WVALID(writer_0_m_axi_WVALID),
        .USB0_VBUS_PWRFAULT(1'b0));
  system_rst_0_0 rst_0
       (.aux_reset_in(1'b1),
        .dcm_locked(pll_0_locked),
        .ext_reset_in(const_0_dout),
        .mb_debug_sys_rst(1'b0),
        .peripheral_aresetn(rst_0_peripheral_aresetn),
        .slowest_sync_clk(pll_0_clk_out1));
  system_slice_0_0 slice_0
       (.din(hub_0_cfg_data),
        .dout(slice_0_dout));
  system_slice_1_0 slice_1
       (.din(hub_0_cfg_data),
        .dout(slice_1_dout));
  system_slice_2_0 slice_2
       (.din(hub_0_cfg_data),
        .dout(slice_2_dout));
  system_slice_3_0 slice_3
       (.din(hub_0_cfg_data),
        .dout(slice_3_dout));
  system_slice_4_0 slice_4
       (.din(hub_0_cfg_data),
        .dout(slice_4_dout));
  system_writer_0_0 writer_0
       (.aclk(pll_0_clk_out1),
        .aresetn(slice_2_dout),
        .cfg_data(const_1_dout),
        .m_axi_awaddr(writer_0_m_axi_AWADDR),
        .m_axi_awburst(writer_0_m_axi_AWBURST),
        .m_axi_awcache(writer_0_m_axi_AWCACHE),
        .m_axi_awid(writer_0_m_axi_AWID),
        .m_axi_awlen(writer_0_m_axi_AWLEN),
        .m_axi_awready(writer_0_m_axi_AWREADY),
        .m_axi_awsize(writer_0_m_axi_AWSIZE),
        .m_axi_awvalid(writer_0_m_axi_AWVALID),
        .m_axi_bready(writer_0_m_axi_BREADY),
        .m_axi_bvalid(writer_0_m_axi_BVALID),
        .m_axi_wdata(writer_0_m_axi_WDATA),
        .m_axi_wid(writer_0_m_axi_WID),
        .m_axi_wlast(writer_0_m_axi_WLAST),
        .m_axi_wready(writer_0_m_axi_WREADY),
        .m_axi_wstrb(writer_0_m_axi_WSTRB),
        .m_axi_wvalid(writer_0_m_axi_WVALID),
        .min_addr(slice_3_dout),
        .s_axis_tdata(pktzr_0_m_axis_TDATA),
        .s_axis_tready(pktzr_0_m_axis_TREADY),
        .s_axis_tvalid(pktzr_0_m_axis_TVALID));
endmodule
