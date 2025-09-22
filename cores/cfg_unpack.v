module cfg_unpack #(
  parameter integer CFG_DATA_WIDTH = 160,
  parameter integer RX_RST_LSB     = 0,    parameter integer RX_RST_WIDTH     = 8,
  parameter integer RX_RATE_LSB    = 16,   parameter integer RX_RATE_WIDTH    = 16,
  parameter integer RX_ADDR_LSB    = 32,   parameter integer RX_ADDR_WIDTH    = 32,
  parameter integer TRG_VALUE_LSB  = 64,   parameter integer TRG_VALUE_WIDTH  = 16,
  parameter integer LIMITER_LSB    = 80,   parameter integer LIMITER_WIDTH    = 8,
  parameter integer BIAS_A_LSB     = 96,   parameter integer BIAS_A_WIDTH     = 16,
  parameter integer BIAS_B_LSB     = 112,  parameter integer BIAS_B_WIDTH     = 16
) (
  input  wire [CFG_DATA_WIDTH-1:0] cfg_data,

  
  // отдельные битовые выходы (по запросу)
  output wire                      nreset_adc,         // rx_rst[0]
  output wire                      nreset_axis_writer, // rx_rst[1]
  output wire                      nreset_trg,         // rx_rst[2]
  output wire                      nreset_max_sum,         // rx_rst[3]

  output wire signed [RX_RATE_WIDTH-1:0] rx_rate,
  output wire [RX_ADDR_WIDTH-1:0]  rx_addr,
  output wire [TRG_VALUE_WIDTH-1:0] trg_value,
  output wire [LIMITER_WIDTH-1:0]  limiter,
  output wire signed [BIAS_A_WIDTH-1:0] bias_ch_A,
  output wire signed [BIAS_B_WIDTH-1:0] bias_ch_B
);
 
 wire [RX_RST_WIDTH-1:0]   rx_rst;
 
  // проверки границ (как было)
  initial begin
    if (RX_RST_LSB + RX_RST_WIDTH   > CFG_DATA_WIDTH)  $error("RX_RST out of range");
    if (RX_RATE_LSB + RX_RATE_WIDTH > CFG_DATA_WIDTH)  $error("RX_RATE out of range");
    if (RX_ADDR_LSB + RX_ADDR_WIDTH > CFG_DATA_WIDTH)  $error("RX_ADDR out of range");
    if (TRG_VALUE_LSB + TRG_VALUE_WIDTH > CFG_DATA_WIDTH)$error("TRG_VALUE out of range");
    if (LIMITER_LSB + LIMITER_WIDTH > CFG_DATA_WIDTH)  $error("LIMITER out of range");
    if (BIAS_A_LSB + BIAS_A_WIDTH   > CFG_DATA_WIDTH)  $error("BIAS_A out of range");
    if (BIAS_B_LSB + BIAS_B_WIDTH   > CFG_DATA_WIDTH)  $error("BIAS_B out of range");
  end

  // срезы
  assign rx_rst    = cfg_data[ RX_RST_LSB + RX_RST_WIDTH - 1 : RX_RST_LSB ];
  assign rx_rate   = cfg_data[ RX_RATE_LSB + RX_RATE_WIDTH - 1 : RX_RATE_LSB ];
  assign rx_addr   = cfg_data[ RX_ADDR_LSB + RX_ADDR_WIDTH - 1 : RX_ADDR_LSB ];
  assign trg_value = cfg_data[ TRG_VALUE_LSB + TRG_VALUE_WIDTH - 1 : TRG_VALUE_LSB ];
  assign limiter   = cfg_data[ LIMITER_LSB + LIMITER_WIDTH - 1 : LIMITER_LSB ];
  assign bias_ch_A = cfg_data[ BIAS_A_LSB + BIAS_A_WIDTH - 1 : BIAS_A_LSB ];
  assign bias_ch_B = cfg_data[ BIAS_B_LSB + BIAS_B_WIDTH - 1 : BIAS_B_LSB ];

  // побитовые выходы (0 - LSB)
  assign nreset_adc         = rx_rst[0]; // 0 бит - сброс ADC_1
  assign nreset_axis_writer = rx_rst[1]; // 1 бит - axis_writer
  assign nreset_trg         = rx_rst[2]; // 2 бит - сброс триггера
  assign nreset_max_sum     = rx_rst[3]; // 3 бит - сброс максимума суммы модулей каналов АЦП

  // при желании можно добавить инверсию (active-low) здесь, например:
  // assign rst_adc = ~rx_rst[0]; // если в логике нужно active-low

endmodule
