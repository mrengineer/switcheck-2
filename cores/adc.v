`timescale 1 ns / 1 ps

module ADC #
(
  parameter integer ADC_DATA_WIDTH = 14
)
(
  // System signals
  input  wire        aclk,
  input  wire        aresetn,      // Active-low reset

  // ADC signals
  output wire        adc_csn,
  input  wire [15:0] adc_dat_a,
  input  wire [15:0] adc_dat_b,

  // Trigger level setting
  input  wire [15:0] trigger_level,

  // Reset control signals
  input  wire        reset_trigger,     // Сброс триггера при 1
  input  wire        reset_max_sum,     // Сброс максимума суммы при 1

  // Master side
  output reg         m_axis_tvalid,
  output wire [15:0] m_axis_tdata
);
  localparam PADDING_WIDTH = 16 - ADC_DATA_WIDTH;

  reg  [ADC_DATA_WIDTH-1:0] int_dat_a_reg;
  reg  [ADC_DATA_WIDTH-1:0] int_dat_b_reg; 
  reg  [ADC_DATA_WIDTH-1:0] abs_a; // Абсолютное значение int_dat_a_reg
  reg  [ADC_DATA_WIDTH-1:0] abs_b; // Абсолютное значение int_dat_b_reg
  reg signed [ADC_DATA_WIDTH:0]   sum_abs; // Additional bit for sum

  reg trigger_activated; // Флаг активации триггера
  reg [15:0]  max_sum_abs;   // Output for maximum sum value  
  reg [63:0]  sample_counter; // 37-битный регистр для подсчета семплов отрабботает год
  reg [15:0]  counter;

  // Process for capturing, inverting ADC data, and calculating maximum sum
  always @(posedge aclk or negedge aresetn) begin
    if (!aresetn) begin
      int_dat_a_reg    <= 0;
      int_dat_b_reg    <= 0;
      abs_a            <= 0;
      abs_b            <= 0;
      sum_abs          <= 0;
      m_axis_tvalid    <= 1'b0;
      trigger_activated <= 1'b0;
      max_sum_abs      <= 0; // Инициализация максимума в 0 на сбросе
      sample_counter   <= 0; // Инициализация счётчика
      counter          <= 0;
    end else begin
      // Увеличиваем счетчик семплов
      sample_counter <= sample_counter + 1;

      // Захватываем данные и обрезаем до нужной ширины
      int_dat_a_reg <= adc_dat_a[15:PADDING_WIDTH];
      int_dat_b_reg <= adc_dat_b[15:PADDING_WIDTH];

      // Вычисляем абсолютные значения
      abs_a <= {1'b0, ~int_dat_a_reg[ADC_DATA_WIDTH-2:0]};      
      abs_b <= {1'b0, ~int_dat_b_reg[ADC_DATA_WIDTH-2:0]};


      // Суммируем абсолютные значения
      sum_abs <= abs_a + abs_b; //{{(PADDING_WIDTH+1){int_dat_a_reg[ADC_DATA_WIDTH-1]}}, ~int_dat_a_reg[ADC_DATA_WIDTH-2:0]};

      if (sample_counter > 2) begin  // Пропустим первые отсчеты после reset потому что по почле reset идет какая-то ерунда
          if (trigger_activated) 
            counter = counter+1;

          // Определяем максимальное значение суммы
          if (sum_abs > max_sum_abs && !reset_max_sum) 
            max_sum_abs <= sum_abs;
          else if (reset_max_sum)
            max_sum_abs <= 0;

          // Проверяем условие для срабатывания триггера и сохраняем состояние
          if (sum_abs > trigger_level && !reset_trigger)
            trigger_activated <= 1'b1;
          else if (reset_trigger)
            trigger_activated <= 1'b0;

          // Устанавливаем m_axis_tvalid, если триггер уже активирован
          m_axis_tvalid <= trigger_activated;

      end
    end
  end

  assign adc_csn = 1'b1;

  // Передаем сумму абсолютных значений на выход
  assign m_axis_tdata =  sum_abs;

endmodule