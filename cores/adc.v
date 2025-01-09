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
  input  wire        reset_trigger,     // Сброс триггера при 1 извне
  input  wire        reset_max_sum,     // Сброс максимума суммы при 1

  // Master side
  output reg         m_axis_tvalid,
  output wire [63:0] m_axis_tdata,
  
  // Output for max_sum_abs
  output reg signed [15:0]  max_sum_out,
  output reg signed [15:0]  trigged_by_out,   // Значение при котором сработал триггер
  output reg [31:0]  trigged_when             // Значение когда сработал триггер
);
  localparam PADDING_WIDTH = 16 - ADC_DATA_WIDTH;

  reg [ADC_DATA_WIDTH-1:0] int_dat_a_reg;
  reg [ADC_DATA_WIDTH-1:0] int_dat_b_reg; 
  //reg [ADC_DATA_WIDTH-1:0] abs_a;             // Абсолютное значение int_dat_a_reg
  //reg [ADC_DATA_WIDTH-1:0] abs_b;             // Абсолютное значение int_dat_b_reg
  reg signed [ADC_DATA_WIDTH:0]   sum_abs;    // С дополнительным битом для суммы


  reg trigger_activated; // Флаг активации триггера


  reg signed [15:0]  max_sum_abs;   // Output for maximum sum value  
  reg signed [15:0]  trigged_by;   // Значение при котором сработал триггер


  reg [32:0] limiter;  // Сколько отсчетов отправлено в шину (без децмации)
  reg [63:0] sample_counter; // 37-битный регистр для подсчета семплов отработает год, 64 бит - 4,6 млн лет. Этого точно хватит. Но мне надо кратно 32 бит, потому 64

  // Process for capturing, inverting ADC data, and calculating maximum sum
  always @(posedge aclk or negedge aresetn) begin
    if (!aresetn) begin
      int_dat_a_reg    <= 0;
      int_dat_b_reg    <= 0;
      //abs_a            <= 0;
      //abs_b            <= 0;
      sum_abs          <= 0;
      m_axis_tvalid    <= 1'b0;
      trigger_activated <= 1'b0;
      max_sum_abs      <= 0;    // Инициализация максимума в 0 на сбросе
      sample_counter   <= 0;    // Инициализация счётчика

      max_sum_out      <= 0;    // Инициализация вывода
      trigged_by_out   <= 0;    // Каким значением max_sum_abs был взведен триггер
      trigged_when     <= 0;
      limiter          <= 0;    
    end else begin

      // Увеличиваем счетчик семплов
      sample_counter <= sample_counter + 1;

      // Захватываем данные и обрезаем до нужной ширины
      int_dat_a_reg <= adc_dat_a[15:PADDING_WIDTH];
      int_dat_b_reg <= adc_dat_b[15:PADDING_WIDTH];

      // Вычисляем абсолютные значения
      //abs_a <= {1'b0, ~int_dat_a_reg[ADC_DATA_WIDTH-2:0]};      
      //abs_b <= {1'b0, ~int_dat_b_reg[ADC_DATA_WIDTH-2:0]};

      // Суммируем абсолютные значения
      sum_abs <= { {(PADDING_WIDTH+1){int_dat_a_reg[ADC_DATA_WIDTH-1]}}, ~int_dat_a_reg[ADC_DATA_WIDTH-2:0]};
      

      if (sample_counter > 2) begin  // Пропустим первые отсчеты после reset, там фигня какая-то сыпется по данным

        // Определяем максимальное значение суммы
        if (sum_abs > max_sum_abs && !reset_max_sum) 
          max_sum_abs <= sum_abs;
        else if (reset_max_sum)
          max_sum_abs <= 0;
        


        // Проверяем условие для срабатывания триггера и сохраняем состояние
        // Актуальное значение выше уровня триггера
        // Мы не в резете триггера, триггер еще не сработал
        if (sum_abs > trigger_level && !reset_trigger && trigger_activated == 0 && limiter==0) begin
          trigged_by_out <= sum_abs;
          trigged_when <= sample_counter;
          trigger_activated <= 1'b1;
        end
        
        if (reset_trigger) begin      // При выставленном сверху сбросе триггера (но не всего блока) сбрасываем его и связанное с ним
          trigged_by_out <= 0;
          trigged_when <= 0;
          trigger_activated <= 1'b0;
          limiter <= 0;
        end
        

        if (limiter > 1000)                    // отрубаем
          trigger_activated <= 1'b0;            // отключаем передачу данных
      
        if (trigger_activated == 1)             // если запись разрешена, то считаем limiter
          limiter <= limiter + 1;

        m_axis_tvalid <= trigger_activated;     // Устанавливаем m_axis_tvalid, если триггер уже активирован        
        max_sum_out <= max_sum_abs;             // Обновляем вывод max_sum_out
      end
    
      
    end
  end

  assign adc_csn = 1'b1;

  // Передаем сумму абсолютных значений на выход
  assign m_axis_tdata = 64'h33333333AABBCCDD; //64'd11223344556677889900; //{sample_counter[47:0], 16'b00001};

endmodule
