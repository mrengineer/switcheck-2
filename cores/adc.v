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
  input  wire [15:0] trigger_level,

  // Reset control signals
  input  wire        reset_trigger,     // Сброс триггера при 1 извне
  input  wire        reset_max_sum,     // Сброс максимума суммы при 1

  // AXI-Stream master (32-bit words)
  output reg         m_axis_tvalid,
  output wire [31:0] m_axis_tdata,
  
  // Output for max_sum_abs
  output reg  signed [15:0] max_sum_out,
  output reg  [63:0]        last_detrigged,     // последний раз пересекли триггер вниз
  output reg  [63:0]        first_trigged,      // первый раз сработал триггер
  output reg  [31:0]        limiter,            // Ограничивает запись числом записей на одно срабатывание
  output reg  [31:0]        samples_sent,       // Число отсчётов, сохранённых в шину
  output reg                trigger_activated,  // Флаг активации триггера
  output reg  [15:0]        triggers_count      // сколько раз сработал триггер
);

  // =========================
  // Параметры и внутренности
  // =========================

  localparam PADDING_WIDTH = 16 - ADC_DATA_WIDTH;
  localparam MID_SCALE     = 1 << (ADC_DATA_WIDTH-1); // для 14 бит: 0x2000

  // Сырые/обработанные данные
  reg  signed [ADC_DATA_WIDTH-1:0] int_dat_a_reg; // signed
  reg  signed [ADC_DATA_WIDTH-1:0] int_dat_b_reg; // signed
  reg         [ADC_DATA_WIDTH-1:0] abs_a;
  reg         [ADC_DATA_WIDTH-1:0] abs_b;
  reg         [ADC_DATA_WIDTH:0]   sum_abs;       // +1 бит на сумму
  reg         [15:0]               max_sum_abs;

  reg  [63:0] sample_counter;

  // =========================
  // Формирование AXI-выхода
  // =========================

  reg [31:0] axis_data_reg;   // Регистр данных на выход
  assign m_axis_tdata = axis_data_reg;

  // Флаги событий для посылки служебных пакетов
  reg prev_trigger_activated;
  reg need_send_cnt_low;
  reg need_send_cnt_high;
  reg need_send_end;

  // =========================
  // Основной процесс
  // =========================

  always @(posedge aclk or negedge aresetn) begin
    if (!aresetn) begin
      int_dat_a_reg         <= 0;
      int_dat_b_reg         <= 0;
      abs_a                 <= 0;
      abs_b                 <= 0;
      sum_abs               <= 0;
      m_axis_tvalid         <= 1'b0;
      axis_data_reg         <= 32'd0;

      trigger_activated     <= 1'b0;
      prev_trigger_activated<= 1'b0;
      triggers_count        <= 0;
      max_sum_abs           <= 0;
      sample_counter        <= 0;
      samples_sent          <= 0;
      max_sum_out           <= 0;
      last_detrigged        <= 0;
      first_trigged         <= 0;
      limiter               <= 32'd0;

      need_send_cnt_low     <= 1'b0;
      need_send_cnt_high    <= 1'b0;
      need_send_end         <= 1'b0;

    end else begin

      // -------------------------
      // Сброс части триггера
      // -------------------------
      if (reset_trigger) begin
        last_detrigged        <= 0;
        first_trigged         <= 0;
        triggers_count        <= 0;
        trigger_activated     <= 1'b0;
        limiter               <= 32'd0;
        need_send_end         <= 1'b0;
        need_send_cnt_low     <= 1'b0;
        need_send_cnt_high    <= 1'b0;
      end

      // -------------------------
      // Счётчик семплов
      // -------------------------
      sample_counter <= sample_counter + 1;

      // -------------------------
      // Захват и нормализация ADC
      // (адаптировано из исходника)
      // -------------------------
      int_dat_a_reg <= {{(PADDING_WIDTH+1){adc_dat_a[ADC_DATA_WIDTH-1]}}, ~adc_dat_a[ADC_DATA_WIDTH-2:0]} + MID_SCALE;
      int_dat_b_reg <= {{(PADDING_WIDTH+1){adc_dat_b[ADC_DATA_WIDTH-1]}}, ~adc_dat_b[ADC_DATA_WIDTH-2:0]} + MID_SCALE;

      abs_a <= int_dat_a_reg[ADC_DATA_WIDTH-1] ? (~int_dat_a_reg + 1) : int_dat_a_reg;
      abs_b <= int_dat_b_reg[ADC_DATA_WIDTH-1] ? (~int_dat_b_reg + 1) : int_dat_b_reg;

      sum_abs <= abs_a + abs_b;

      // Пропустим первые несколько отсчётов (как было: >2)
      if (sample_counter > 2) begin
        // Трекинг максимума
        if (sum_abs > max_sum_abs && !reset_max_sum)
          max_sum_abs <= sum_abs;
        else if (reset_max_sum)
          max_sum_abs <= 0;

        // -------------------------
        // Логика триггера
        // -------------------------
        // Включение
        if (sum_abs > trigger_level && !reset_trigger && trigger_activated == 1'b0) begin
          limiter               <= 32'd0;
          first_trigged         <= sample_counter;
          trigger_activated     <= 1'b1;
          triggers_count        <= triggers_count + 1;

          // При фронте триггера нужно отправить счётчик (2 слова)
          need_send_cnt_low     <= 1'b1;
          need_send_cnt_high    <= 1'b1;
        end

        // Выключение (по уровню)
        if (sum_abs < trigger_level && !reset_trigger && trigger_activated == 1'b1) begin
          last_detrigged        <= sample_counter;
          trigger_activated     <= 1'b0;
          need_send_end         <= 1'b1;   // по спаду - отправить окончание
        end

        // Ограничение длины серии
        if (limiter > 32'd70 && trigger_activated == 1'b1) begin
          trigger_activated     <= 1'b0;   // отрубить
          need_send_end         <= 1'b1;   // и отправить окончание
        end

        // Счётчики в активном режиме
        if (trigger_activated == 1'b1) begin
          limiter               <= limiter + 1;
          samples_sent          <= samples_sent + 1;
        end

        // Вывод статистики
        max_sum_out <= max_sum_abs;
      end

      // -------------------------
      // Формирование AXI-Stream
      // Очерёдность: cnt_low -> cnt_high -> data(если активен) -> end
      // За такт уходит максимум 1 слово.
      // -------------------------
      m_axis_tvalid <= 1'b0; // по умолчанию

      // Фронт/спад триггера детектируем
      prev_trigger_activated <= trigger_activated;

      // 1) Если нужно отправить счетчик (после фронта)
      if (need_send_cnt_low) begin
        axis_data_reg     <= {2'b00, sample_counter[29:0]};
        m_axis_tvalid     <= 1'b1;
        need_send_cnt_low <= 1'b0;
      end else if (need_send_cnt_high) begin
        axis_data_reg      <= {2'b01, sample_counter[59:30]};
        m_axis_tvalid      <= 1'b1;
        need_send_cnt_high <= 1'b0;

      // 2) Пока активен триггер - шлём данные АЦП
      end else if (trigger_activated) begin
        // преобразуем в unsigned 15 бит: signed->shift на MID_SCALE, затем ограничить в 0..32767
        // int_dat_* имеет ширину ADC_DATA_WIDTH (14), суммарно влезет.
        // Сначала расширим до 16, потом сместим и ограничим.
        // Синтезатор выполнит это комбинаторно.
        // Собираем пакет: { A_u[14:0], B_u[14:0] }
        // Примечание: старший бит полезной части - бит 29.
        // Для предсказуемости используем регистровое вычисление ниже.
        // (См. доп. блок always_comb ниже) - здесь просто шлём подготовленные поля.
        axis_data_reg  <= {2'b10, a_u15, b_u15};
        m_axis_tvalid  <= 1'b1;

      // 3) Если нужно отправить окончание
      end else if (need_send_end) begin
        axis_data_reg  <= {2'b11, 30'd0};
        m_axis_tvalid  <= 1'b1;
        need_send_end  <= 1'b0;
      end

    end
  end

  // =========================
  // Подготовка 15-бит unsigned A/B
  // =========================
  // Сместим signed к unsigned и ограничим в 0..32767 (15 бит).
  // Для корректности на любой ADC_DATA_WIDTH<=15.
  wire signed [15:0] a_ext = {{(16-ADC_DATA_WIDTH){int_dat_a_reg[ADC_DATA_WIDTH-1]}}, int_dat_a_reg};
  wire signed [15:0] b_ext = {{(16-ADC_DATA_WIDTH){int_dat_b_reg[ADC_DATA_WIDTH-1]}}, int_dat_b_reg};

    // Берём 15 младших бит, со знаком
    wire [14:0] a_u15 = a_ext[14:0];
    wire [14:0] b_u15 = b_ext[14:0];


  //wire [16:0] a_shift = a_ext + MID_SCALE; // теоретически 0..2*MID_SCALE-1
  //wire [16:0] b_shift = b_ext + MID_SCALE;

  //wire [14:0] a_u15 = (a_shift[16:15] != 2'b00) ? 15'h7FFF : a_shift[14:0]; // clamp сверху
  //wire [14:0] b_u15 = (b_shift[16:15] != 2'b00) ? 15'h7FFF : b_shift[14:0];

  // =========================
  // Прочие связи
  // =========================

  assign adc_csn     = 1'b1;
  assign cur_adc     = sum_abs;
  assign cur_sample  = sample_counter;

endmodule


/*
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
  localparam MID_SCALE = 1 << (ADC_DATA_WIDTH-1); // для 14 бит: 0x2000

  reg signed [ADC_DATA_WIDTH-1:0] int_dat_a_reg;           //signed. Поэтому ADC_DATA_WIDTH-1
  reg signed [ADC_DATA_WIDTH-1:0] int_dat_b_reg; 
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

    if (reset_trigger) begin      // При выставленном сверху сбросе тригера (но не всего блока, а только части) сбрасываем его и связанное с ним
          last_detrigged    <= 0;
          first_trigged     <= 0;
          triggers_count    <= 0;
          trigger_activated <= 1'b0;          
          limiter           <= 1'b0;
    end


      // Увеличиваем счетчик семплов
      sample_counter <= sample_counter + 1;


      // Захватываем данные, обрезаем до нужной ширины и убираем смещение mid-scale (8192 - ноль ацп)
      int_dat_a_reg <=  {{(PADDING_WIDTH+1){adc_dat_a[ADC_DATA_WIDTH-1]}}, ~adc_dat_a[ADC_DATA_WIDTH-2:0]} + MID_SCALE;
      int_dat_b_reg <=  {{(PADDING_WIDTH+1){adc_dat_b[ADC_DATA_WIDTH-1]}}, ~adc_dat_b[ADC_DATA_WIDTH-2:0]} + MID_SCALE;
        
        // Берём младшие ADC_DATA_WIDTH бит и смещаем mid-scale к 0
        //int_dat_a_reg <= -16'd20; //Проверить что идут отрицательные числа
              
      // Абсолютное значение каждого канала
      abs_a <= int_dat_a_reg[ADC_DATA_WIDTH-1] ? (~int_dat_a_reg + 1) : int_dat_a_reg;
      abs_b <= int_dat_b_reg[ADC_DATA_WIDTH-1] ? (~int_dat_b_reg + 1) : int_dat_b_reg;


      // Суммируем абсолютные значения
      //sum_abs <= {
      //  {(PADDING_WIDTH+1){int_dat_a_reg[ADC_DATA_WIDTH-1]}}, ~int_dat_a_reg[ADC_DATA_WIDTH-2:0]} + {{(PADDING_WIDTH+1){int_dat_b_reg[ADC_DATA_WIDTH-1]}}, ~int_dat_b_reg[ADC_DATA_WIDTH-2:0]};
      sum_abs <= abs_a + abs_b;


      if (sample_counter > 4) begin  // Пропустим первые отсчеты после reset, там фигня какая-то сыпется по данным

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
        
        

        if (limiter > 32'd70)                    // отрубаем
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
    // int_dat_a_reg: sign-extend до 16 бит
    { {(16-ADC_DATA_WIDTH){int_dat_a_reg[ADC_DATA_WIDTH-1]}}, int_dat_a_reg },

    // int_dat_b_reg: sign-extend до 16 бит
    { {(16-ADC_DATA_WIDTH){int_dat_b_reg[ADC_DATA_WIDTH-1]}}, int_dat_b_reg },
    { {(16-(ADC_DATA_WIDTH+1)){1'b0}}, sum_abs },  // расширяем до 16
    16'hA1B2                                       // 16 бит
};

// Для проверки передачи данных и их разбора
//assign m_axis_tdata = {
//    64'hFFFFFFFFFFFFFFFF,
//    16'h8001, // -32767 в 2's complement для 16 бит
//    16'h7FFF, // 32767
//    16'hF1F2,
//    16'hABCD
//};


  assign cur_adc = sum_abs;
  assign cur_sample = sample_counter;

endmodule
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
  input  wire [15:0] trigger_level,

  // Reset control signals
  input  wire        reset_trigger,     // Сброс триггера при 1 извне
  input  wire        reset_max_sum,     // Сброс максимума суммы при 1

  // AXI-Stream master (32-bit words)
  output reg         m_axis_tvalid,
  output wire [31:0] m_axis_tdata,
  
  // Output for max_sum_abs
  output reg  signed [15:0] max_sum_out,
  output reg  [63:0]        last_detrigged,     // последний раз пересекли триггер вниз
  output reg  [63:0]        first_trigged,      // первый раз сработал триггер
  output reg  [31:0]        limiter,            // Ограничивает запись числом записей на одно срабатывание
  output reg  [31:0]        samples_sent,       // Число отсчётов, сохранённых в шину
  output reg                trigger_activated,  // Флаг активации триггера
  output reg  [15:0]        triggers_count      // сколько раз сработал триггер
);

  // =========================
  // Параметры и внутренности
  // =========================

  localparam PADDING_WIDTH = 16 - ADC_DATA_WIDTH;
  localparam MID_SCALE     = 1 << (ADC_DATA_WIDTH-1); // для 14 бит: 0x2000

  // Сырые/обработанные данные
  reg  signed [ADC_DATA_WIDTH-1:0] int_dat_a_reg; // signed
  reg  signed [ADC_DATA_WIDTH-1:0] int_dat_b_reg; // signed
  reg         [ADC_DATA_WIDTH-1:0] abs_a;
  reg         [ADC_DATA_WIDTH-1:0] abs_b;
  reg         [ADC_DATA_WIDTH:0]   sum_abs;       // +1 бит на сумму
  reg         [15:0]               max_sum_abs;

  reg  [63:0] sample_counter;

  // =========================
  // Формирование AXI-выхода
  // =========================

  reg [31:0] axis_data_reg;   // Регистр данных на выход
  assign m_axis_tdata = axis_data_reg;

  // Флаги событий для посылки служебных пакетов
  reg prev_trigger_activated;
  reg need_send_cnt_low;
  reg need_send_cnt_high;
  reg need_send_end;

  // =========================
  // Основной процесс
  // =========================

  always @(posedge aclk or negedge aresetn) begin
    if (!aresetn) begin
      int_dat_a_reg         <= 0;
      int_dat_b_reg         <= 0;
      abs_a                 <= 0;
      abs_b                 <= 0;
      sum_abs               <= 0;
      m_axis_tvalid         <= 1'b0;
      axis_data_reg         <= 32'd0;

      trigger_activated     <= 1'b0;
      prev_trigger_activated<= 1'b0;
      triggers_count        <= 0;
      max_sum_abs           <= 0;
      sample_counter        <= 0;
      samples_sent          <= 0;
      max_sum_out           <= 0;
      last_detrigged        <= 0;
      first_trigged         <= 0;
      limiter               <= 32'd0;

      need_send_cnt_low     <= 1'b0;
      need_send_cnt_high    <= 1'b0;
      need_send_end         <= 1'b0;

    end else begin

      // -------------------------
      // Сброс части триггера
      // -------------------------
      if (reset_trigger) begin
        last_detrigged        <= 0;
        first_trigged         <= 0;
        triggers_count        <= 0;
        trigger_activated     <= 1'b0;
        limiter               <= 32'd0;
        need_send_end         <= 1'b0;
        need_send_cnt_low     <= 1'b0;
        need_send_cnt_high    <= 1'b0;
      end

      // -------------------------
      // Счётчик семплов
      // -------------------------
      sample_counter <= sample_counter + 1;

      // -------------------------
      // Захват и нормализация ADC
      // (адаптировано из исходника)
      // -------------------------
      int_dat_a_reg <= {{(PADDING_WIDTH+1){adc_dat_a[ADC_DATA_WIDTH-1]}}, ~adc_dat_a[ADC_DATA_WIDTH-2:0]} + MID_SCALE;
      int_dat_b_reg <= {{(PADDING_WIDTH+1){adc_dat_b[ADC_DATA_WIDTH-1]}}, ~adc_dat_b[ADC_DATA_WIDTH-2:0]} + MID_SCALE;

      abs_a <= int_dat_a_reg[ADC_DATA_WIDTH-1] ? (~int_dat_a_reg + 1) : int_dat_a_reg;
      abs_b <= int_dat_b_reg[ADC_DATA_WIDTH-1] ? (~int_dat_b_reg + 1) : int_dat_b_reg;

      sum_abs <= abs_a + abs_b;

      // Пропустим первые несколько отсчётов (как было: >4)
      if (sample_counter > 4) begin
        // Трекинг максимума
        if (sum_abs > max_sum_abs && !reset_max_sum)
          max_sum_abs <= sum_abs;
        else if (reset_max_sum)
          max_sum_abs <= 0;

        // -------------------------
        // Логика триггера
        // -------------------------
        // Включение
        if (sum_abs > trigger_level && !reset_trigger && trigger_activated == 1'b0) begin
          limiter               <= 32'd0;
          first_trigged         <= sample_counter;
          trigger_activated     <= 1'b1;
          triggers_count        <= triggers_count + 1;

          // При фронте триггера нужно отправить счётчик (2 слова)
          need_send_cnt_low     <= 1'b1;
          need_send_cnt_high    <= 1'b1;
        end

        // Выключение (по уровню)
        if (sum_abs < trigger_level && !reset_trigger && trigger_activated == 1'b1) begin
          last_detrigged        <= sample_counter;
          trigger_activated     <= 1'b0;
          need_send_end         <= 1'b1;   // по спаду — отправить окончание
        end

        // Ограничение длины серии
        if (limiter > 32'd70 && trigger_activated == 1'b1) begin
          trigger_activated     <= 1'b0;   // отрубить
          need_send_end         <= 1'b1;   // и отправить окончание
        end

        // Счётчики в активном режиме
        if (trigger_activated == 1'b1) begin
          limiter               <= limiter + 1;
          samples_sent          <= samples_sent + 1;
        end

        // Вывод статистики
        max_sum_out <= max_sum_abs;
      end

      // -------------------------
      // Формирование AXI-Stream
      // Очерёдность: cnt_low -> cnt_high -> data(если активен) -> end
      // За такт уходит максимум 1 слово.
      // -------------------------
      m_axis_tvalid <= 1'b0; // по умолчанию

      // Фронт/спад триггера детектируем
      prev_trigger_activated <= trigger_activated;

      // 1) Если нужно отправить счетчик (после фронта)
      if (need_send_cnt_low) begin
        axis_data_reg     <= {2'b00, sample_counter[29:0]};
        m_axis_tvalid     <= 1'b1;
        need_send_cnt_low <= 1'b0;
      end else if (need_send_cnt_high) begin
        axis_data_reg      <= {2'b01, sample_counter[59:30]};
        m_axis_tvalid      <= 1'b1;
        need_send_cnt_high <= 1'b0;

      // 2) Пока активен триггер — шлём данные АЦП
      end else if (trigger_activated) begin
        // преобразуем в unsigned 15 бит: signed->shift на MID_SCALE, затем ограничить в 0..32767
        // int_dat_* имеет ширину ADC_DATA_WIDTH (14), суммарно влезет.
        // Сначала расширим до 16, потом сместим и ограничим.
        // Синтезатор выполнит это комбинаторно.
        // Собираем пакет: { A_u[14:0], B_u[14:0] }
        // Примечание: старший бит полезной части — бит 29.
        // Для предсказуемости используем регистровое вычисление ниже.
        // (См. доп. блок always_comb ниже) — здесь просто шлём подготовленные поля.
        axis_data_reg  <= {2'b10, a_u15, b_u15};
        m_axis_tvalid  <= 1'b1;

      // 3) Если нужно отправить окончание
      end else if (need_send_end) begin
        axis_data_reg  <= {2'b11, 30'd0};
        m_axis_tvalid  <= 1'b1;
        need_send_end  <= 1'b0;
      end

    end
  end

  // =========================
  // Подготовка 15-бит unsigned A/B
  // =========================
  // Сместим signed к unsigned и ограничим в 0..32767 (15 бит).
  // Для корректности на любой ADC_DATA_WIDTH<=15.
  wire signed [15:0] a_ext = {{(16-ADC_DATA_WIDTH){int_dat_a_reg[ADC_DATA_WIDTH-1]}}, int_dat_a_reg};
  wire signed [15:0] b_ext = {{(16-ADC_DATA_WIDTH){int_dat_b_reg[ADC_DATA_WIDTH-1]}}, int_dat_b_reg};

  wire [16:0] a_shift = a_ext + MID_SCALE; // теоретически 0..2*MID_SCALE-1
  wire [16:0] b_shift = b_ext + MID_SCALE;

  wire [14:0] a_u15 = (a_shift[16:15] != 2'b00) ? 15'h7FFF : a_shift[14:0]; // clamp сверху
  wire [14:0] b_u15 = (b_shift[16:15] != 2'b00) ? 15'h7FFF : b_shift[14:0];

  // =========================
  // Прочие связи
  // =========================

  assign adc_csn     = 1'b1;
  assign cur_adc     = sum_abs[15:0];
  assign cur_sample  = sample_counter;

endmodule
*/