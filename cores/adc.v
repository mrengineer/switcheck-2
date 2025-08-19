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

  output wire [15:0] cur_adc,
  output wire [63:0] cur_sample, 

  // Trigger level setting
  input wire [15:0] trigger_level,

  // Reset control signals
  input  wire       reset_trigger,     // Сброс триггера при 1 извне
  input  wire       reset_max_sum,     // Сброс максимума суммы при 1

  // Master side
  output reg          m_axis_tvalid,
  output wire [128:0] m_axis_tdata,
  
  // Output for max_sum_abs
  output reg signed [15:0]  max_sum_out,
  output reg [63:0] last_detrigged,     // последний раз пересекли триггер вниз
  output reg [63:0] first_trigged,      // первый раз сработал триггер
  output reg [31:0] limiter,            // Ограничивает запись в шину числом записей на одно срабатывание
  output reg [31:0] samples_sent,      // Число отсечтов, сохраненных в шину
  output reg trigger_activated,         // Флаг активации триггера
  
  output reg [15:0] triggers_count      // сколько раз сработал тригер
  
);
  localparam PADDING_WIDTH = 16 - ADC_DATA_WIDTH;

  reg [ADC_DATA_WIDTH-1:0] int_dat_a_reg;           //signed. Поэтому ADC_DATA_WIDTH-1
  reg [ADC_DATA_WIDTH-1:0] int_dat_b_reg; 
  reg [ADC_DATA_WIDTH-1:0] abs_a;             // Абсолютное значение int_dat_a_reg
  reg [ADC_DATA_WIDTH-1:0] abs_b;             // Абсолютное значение int_dat_b_reg
  
  reg [ADC_DATA_WIDTH:0]   sum_abs;    // С дополнительным битом для суммы

  reg [15:0]  max_sum_abs;   // Output for maximum sum value  
  
  reg [63:0] sample_counter; // 37-битный регистр для подсчета семплов отработает год, 64 бит - 4,6 млн лет. Этого точно хватит. Учитывая размерность шины я могу позволить 47 (71 год)

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
      triggers_count   <= 0;
      max_sum_abs      <= 0;    // Инициализация максимума в 0 на сбросе
      sample_counter   <= 0;    // Инициализация счётчика
      samples_sent     <= 0;

      max_sum_out      <= 0;    // Инициализация вывода
      last_detrigged   <= 0;
      first_trigged    <= 0;
      limiter          <= 1'b0;    
    end 
    else 
    begin

      // Увеличиваем счетчик семплов
      sample_counter <= sample_counter + 1;

      // Захватываем данные, обрезаем до нужной ширины и убираем смещение mid-scale (8192 - ноль ацп)
      int_dat_a_reg <= adc_dat_a[15:PADDING_WIDTH]  - (1 << (ADC_DATA_WIDTH-1));  // - (1 << (ADC_DATA_WIDTH-1)) смещает на 8192
      int_dat_b_reg <= adc_dat_b[15:PADDING_WIDTH]  - (1 << (ADC_DATA_WIDTH-1));

        // Абсолютное значение каждого канала
      abs_a <= int_dat_a_reg[ADC_DATA_WIDTH-1] ? (~int_dat_a_reg + 1) : int_dat_a_reg;
      abs_b <= int_dat_b_reg[ADC_DATA_WIDTH-1] ? (~int_dat_b_reg + 1) : int_dat_b_reg;


      // Суммируем абсолютные значения
      //sum_abs <= {
      //  {(PADDING_WIDTH+1){int_dat_a_reg[ADC_DATA_WIDTH-1]}}, ~int_dat_a_reg[ADC_DATA_WIDTH-2:0]} + {{(PADDING_WIDTH+1){int_dat_b_reg[ADC_DATA_WIDTH-1]}}, ~int_dat_b_reg[ADC_DATA_WIDTH-2:0]};
      sum_abs <= abs_a + abs_b;


      if (sample_counter > 2) begin  // Пропустим первые отсчеты после reset, там фигня какая-то сыпется по данным

        // Определяем максимальное значение суммы
        if (sum_abs > max_sum_abs && !reset_max_sum) 
          max_sum_abs <= sum_abs;
        else if (reset_max_sum)
          max_sum_abs <= 0;
        

        // Проверяем условие для срабатывания триггера и сохраняем состояние
        // Актуальное значение выше уровня триггера
        // Мы не в резете триггера, триггер еще не сработал
        if (sum_abs > trigger_level && !reset_trigger && trigger_activated == 1'b0) begin       // && limiter==1'b0          
          //trigged_by_out <= sum_abs;
          
          limiter <= 1'b0;
          
          //if (first_trigged == 0) //не сбрасывать номер отсчета срабатывания тригера
          first_trigged     <= sample_counter;
            
          trigger_activated <= 1'b1;
          triggers_count    <= triggers_count + 1;
        end
        
        
        if (sum_abs < trigger_level && !reset_trigger && trigger_activated == 1'b1) begin
          last_detrigged    <= sample_counter;
          trigger_activated <= 1'b0;
        end        
        
        if (reset_trigger) begin      // При выставленном сверху сбросе триггера (но не всего блока, а только части) сбрасываем его и связанное с ним
          last_detrigged    <= 0;
          first_trigged     <= 0;
          triggers_count    <= 0;
          trigger_activated <= 1'b0;
          limiter           <= 1'b0;
        end
        

        if (limiter > 32'd3000)                    // отрубаем
          trigger_activated <= 1'b0;            // отключаем передачу данных
      
        if (trigger_activated == 1'b1) begin            // если запись разрешена, то считаем limiter и число отсчетов, ушедших в шину
          limiter          <= limiter + 1;
          samples_sent     <= samples_sent + 1;
         end

        //first_trigged  <= 64'hA1B2C3C4D5E6F788;
        //last_detrigged <= 64'h1122AABBCCDDEEFF;
        //limiter <= 32'd65511;
        
        m_axis_tvalid   <= trigger_activated;     // Устанавливаем m_axis_tvalid, если триггер уже активирован        
        max_sum_out     <= max_sum_abs;             // Обновляем вывод max_sum_out
      end
    
      
    end
  end

  assign adc_csn = 1'b1;

  // Передаем сумму абсолютных значений на выход

//  assign m_axis_tdata = {sample_counter, sum_abs,  16'hA1B2};
assign m_axis_tdata = {
    sample_counter,                                // 64 бита
    { {(16-ADC_DATA_WIDTH){1'b0}}, int_dat_a_reg },// расширяем до 16, знаковое
    { {(16-ADC_DATA_WIDTH){1'b0}}, int_dat_b_reg },// расширяем до 16
    { {(16-(ADC_DATA_WIDTH+1)){1'b0}}, sum_abs },  // расширяем до 16
    16'hA1B2                                       // 16 бит
};

// Для проверки передачи данных и их разбора
/*assign m_axis_tdata = {
    64'hFFFFFFFFFFFFFFFF,
    16'h8001, // -32767 в 2's complement для 16 бит
    16'h7FFF, // 32767
    16'hF1F2,
    16'hABCD
};*/


  assign cur_adc = sum_abs;
  assign cur_sample = sample_counter;

endmodule

/*
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
  reg signed [ADC_DATA_WIDTH:0]   sum_abs;    // С дополнительным битом для суммы

  reg trigger_activated; // Флаг активации триггера

  reg signed [15:0]  max_sum_abs;   // Output for maximum sum value  
  reg signed [15:0]  trigged_by;   // Значение при котором сработал триггер
  
  reg [48:0] sample_counter; // 37-битный регистр для подсчета семплов отработает год, 64 бит - 4,6 млн лет. Этого точно хватит. Учитывая размерность шины я могу позволить 47 (71 год)
  
  
  reg [48:0] lim;
 
  // Process for capturing, inverting ADC data, and calculating maximum sum
  always @(posedge aclk or negedge aresetn) begin
    if (!aresetn) begin
      int_dat_a_reg    <= 0;
      int_dat_b_reg    <= 0;
      sum_abs          <= 0;
      m_axis_tvalid    <= 0;
      trigger_activated <= 1'b0;
      max_sum_abs      <= 0;    // Инициализация максимума в 0 на сбросе
      sample_counter   <= 0;    // Инициализация счётчика

      max_sum_out      <= 0;    // Инициализация вывода
      trigged_by_out   <= 0;    // Каким значением max_sum_abs был взведен триггер
      trigged_when     <= 0;
      lim <= 0;
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
      

      if (sample_counter > 1) begin  // Пропустим первые отсчеты после reset, там фигня какая-то сыпется по данным

        // Определяем максимальное значение суммы
        if (sum_abs > max_sum_abs && !reset_max_sum) 
          max_sum_abs <= sum_abs;
        else if (reset_max_sum)
          max_sum_abs <= 0;        

        // Проверяем условие для срабатывания триггера и сохраняем состояние
        // Актуальное значение выше уровня триггера Мы не в резете триггера, триггер еще не сработал
        if (sum_abs > trigger_level && !reset_trigger && trigger_activated == 1'b0) begin
          trigged_by_out        <= sum_abs;
          trigged_when          <= sample_counter;
          trigger_activated     <= 1'b1;
        end
        
//        if (sum_abs < trigger_level && !reset_trigger && trigger_activated) begin
//          trigger_activated <= 0;
//        end

        
        if (reset_trigger) begin      // При выставленном сверху сбросе триггера (но не всего блока) сбрасываем его и связанное с ним
          trigged_by_out    <= 0;
          trigged_when      <= 0;
          trigger_activated <= 1'b0;
        end
 

        if (trigger_activated == 1'b1)
            lim <= lim + 1;

        if (lim > 2000)
            lim <= 2001;
            trigger_activated <= 0;
                           
        
        m_axis_tvalid   <= trigger_activated;       // Устанавливаем m_axis_tvalid, если триггер уже активирован        
        max_sum_out     <= max_sum_abs;             // Обновляем вывод max_sum_abs
      end
      
    end
  end

  assign adc_csn = 1'b1;

  // Передаем сумму абсолютных значений на выход
  assign m_axis_tdata = {lim, 16'd1234};

endmodule
*/
