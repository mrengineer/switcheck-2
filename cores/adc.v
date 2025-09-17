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
        
        input wire  [ 7:0] limiter,           // Сколько писать отсчетов в серии максимум (число 2^limiter) 
        


        // Trigger level setting
        input  wire [15:0] trigger_level,

        // Reset control signals
        input  wire        reset_trigger,     // Сброс триггера при 1 извне
        input  wire        reset_max_sum,     // Сброс максимума суммы при 1

        // AXI-Stream master (32-bit words)
        output reg         m_axis_tvalid,
        output reg         m_axis_tlast,        // AXI-Stream tlast        
        output wire [31:0] m_axis_tdata,
        
        // Output for max_sum_abs
        output reg  signed [15:0] max_sum_out,
        output reg  [63:0]        last_detrigged,     // последний раз пересекли триггер вниз
        output reg  [63:0]        first_trigged,      // первый раз сработал триггер
        output reg  [63:0]        cur_limiter,        // Ограничивает запись числом записей на одну серию
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



wire [63:0] limiter_val;             // чтобы ограничить limiter, 
// ограничиваем максимум 63, иначе будет переполнение при (1 << limiter)
assign limiter_val = (limiter > 8'd63) ? 64'hFFFF_FFFF_FFFF_FFFF : (64'd1 << limiter);


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

reg trigger_now;   // временный флаг

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

        trigger_activated     <= 0;
        trigger_now           <= 1'b0;
        triggers_count        <= 0;
        max_sum_abs           <= 0;
        sample_counter        <= 64'd0;
        samples_sent          <= 0;
        max_sum_out           <= 0;
        last_detrigged        <= 0;
        first_trigged         <= 0;
        cur_limiter           <= 0;

        // need_send_cnt_low     <= 1'b0;
        // need_send_cnt_high    <= 1'b0;
        // need_send_end         <= 1'b0;

    end else begin

        // -------------------------
        // Сброс части триггера
        // -------------------------
        if (!reset_trigger) begin
            last_detrigged        <= 0;
            first_trigged         <= 0;
            triggers_count        <= 0;
            
            trigger_activated     <= 0;
            cur_limiter           <= 0;
            
            trigger_now             <= 1'b0;
        end
        else // AfoninAS: размещаем в else все, что сбрасывается по reset_trigger
        begin 
        
            //last_detrigged <= limiter_val;

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


            trigger_now = ((trigger_level <= sum_abs) || trigger_activated);  // сделано чтобы избежать блокирующего присвоения и иметь значение прямо на этом такте

            // Срабатывание тригера
            if (trigger_now && !trigger_activated) begin
                trigger_activated <= 1;  // Запомним на следующий такт
                triggers_count  <= triggers_count+1;
                first_trigged   <= sample_counter;
            end


            // Формирование AXI-Stream
            // За такт уходит максимум 1 слово.
            // -------------------------
            // m_axis_tvalid <= 1'b0; // по умолчаниюm_axis_tvalid - AfoninAS: так писать неправильно, нужно под else убрать
            // || ()

            if (trigger_now == 1'b1) begin
            
                if (sum_abs <= trigger_level) begin
                    last_detrigged          <= sample_counter;
                end
                              
                // Отключение посылки данных если достигнуто максимальное число отсчетов на серию или или сумма значений менее тригера
                if ((cur_limiter == limiter_val-1) ) begin            // AfoninAS: так как m_axis_tvalid опускается с задержкой на так по trigger_activated, счетчик д.б. на 1 меньше
                    trigger_activated       <= 0;
                    axis_data_reg           <= {2'b11, a_u15, b_u15};        //  AfoninAS: помечаем последнее (32е) слово в пачке из 32 слов
                    samples_sent            <= samples_sent + 1;
                    cur_limiter             <= 0;                    
                    m_axis_tlast            <= 1'b1;                     // конец пакета, завершить burst в writer даже если не кратно 32
                end else begin
                    if (sum_abs <= trigger_level) begin
                        axis_data_reg           <= {2'b10, a_u15, b_u15};
                        samples_sent            <= samples_sent + 1;
                        cur_limiter             <= cur_limiter + 1;
                        m_axis_tlast            <= 1'b0;
                    end else begin
                        axis_data_reg           <= {2'b00, a_u15, b_u15};
                        samples_sent            <= samples_sent + 1;
                        cur_limiter             <= cur_limiter + 1;
                        m_axis_tlast            <= 1'b0;                    
                    end
                    
                end

                m_axis_tvalid <= 1'b1; // AfoninAS: при активном триггере поднимаем tvalid, задержка на такт относительно trigger_activated
            end else begin
                m_axis_tvalid <= 1'b0; // AfoninAS: при неактивном триггере опускаем tvalid, задержка на такт относительно trigger_activated
                m_axis_tlast  <= 1'b0;
            end
        end


         


        // Трекинг максимума
        if (reset_max_sum) // AfoninAS: приоритет сброса выше, чем обновления суммы, переставляем местами и убираем лишнее условие в else
            max_sum_abs <= 0;
        else if (sum_abs > max_sum_abs)
            max_sum_abs <= sum_abs;

        // Вывод статистики
        max_sum_out <= max_sum_abs;

    end
end




// =========================
// Прочие связи
// =========================

assign adc_csn     = 1'b1;
assign cur_adc     = sum_abs;
assign cur_sample  = sample_counter;

endmodule
