`timescale 1ns / 1ps
// sts_pack.v
//
// Упаковщик регистров статуса для передачи в AXI
// Все поля собираются в единый вектор шириной TOTAL_WIDTH.
// Если общая ширина меньше - дополняем нулями,
// если больше - выдаём ошибку синтеза.

module sts_pack #(
    parameter integer TOTAL_WIDTH          = 160, // итоговая ширина
    parameter integer WIDTH_RX_CNTR        = 32,  // writer0 сообщает, сколько данных записано в память
    parameter integer WIDTH_ADC_ABS_MAX    = 16,  // максимальное значение (для автокалибровки триггера)
    parameter integer WIDTH_CUR_ADC        = 16,  // текущее значение суммы модуля каналов A и B
    parameter integer WIDTH_LAST_DETRIGGED = 64,  // последний момент (в семплах), когда триггер перешёл вниз
    parameter integer WIDTH_FIRST_TRGGED   = 64,  // первый момент (в семплах), когда сработал триггер
    parameter integer WIDTH_ADC_SENT       = 32,  // сколько отсчётов АЦП отправленов шину
    parameter integer WIDTH_TRIG_ACT       = 16,  // состояние триггера (бит-флаг активен/не активен)
    parameter integer WIDTH_TRIG_COUNT     = 16,  // количество сработок триггера
    parameter integer WIDTH_SAMPLES_COUNT  = 64,  // общий счетчик семплов
    parameter integer WIDTH_ADC_CH         = 16   // длина слова с текущим значением канала АЦП
)(
    // === входы ===
    input  wire [WIDTH_RX_CNTR-1:0]        rx_cntr,           // [0]   writer0 сколько данных записано в память    
    input  wire [WIDTH_ADC_CH-1:0]         cur_adc_a,         // [9]   канал АЦП А
    input  wire [WIDTH_ADC_CH-1:0]         cur_adc_b,         // [10]   канал АЦП А    
    input  wire [WIDTH_CUR_ADC-1:0]        cur_adc,           // [2]   текущее значение суммы модуля каналов A и B    
    input  wire [WIDTH_SAMPLES_COUNT-1:0]  samples_count,     // [8]   общий счетчик семплов с момента reset    
    input  wire [WIDTH_ADC_ABS_MAX-1:0]    adc_abs_max,       // [1]   максимальное значение суммы модулей каналов A и B
    input  wire [WIDTH_LAST_DETRIGGED-1:0] last_detrigged,    // [3]   время последнего спада триггера (в семплах)
    input  wire [WIDTH_FIRST_TRGGED-1:0]   first_trgged,      // [4]   время первого срабатывания триггера (в семплах)
    input  wire [WIDTH_ADC_SENT-1:0]       adc_sent,          // [5]   количество отправленных в шину отсчетов АЦП
    input  wire [WIDTH_TRIG_ACT-1:0]       trigger_activated, // [6]   состояние триггера (флаг)
    input  wire [WIDTH_TRIG_COUNT-1:0]     triggers_count,    // [7]   количество сработок триггера


    // === выход ===
    output wire [TOTAL_WIDTH-1:0]          sts_bus            // упакованный статусный вектор
);

    // Посчитаем суммарную ширину всех полей
    localparam integer FIELDS_WIDTH =
          WIDTH_RX_CNTR
        + WIDTH_ADC_ABS_MAX
        + WIDTH_CUR_ADC
        + WIDTH_LAST_DETRIGGED
        + WIDTH_FIRST_TRGGED
        + WIDTH_ADC_SENT
        + WIDTH_TRIG_ACT
        + WIDTH_TRIG_COUNT
        + WIDTH_SAMPLES_COUNT
        + WIDTH_ADC_CH 
        + WIDTH_ADC_CH;

    // Проверка: если суммарная ширина > TOTAL_WIDTH, выдаём ошибку
    initial begin
        if (FIELDS_WIDTH > TOTAL_WIDTH) begin
            $error("sts_pack: ширина всех полей (%0d) превышает TOTAL_WIDTH (%0d)",
                   FIELDS_WIDTH, TOTAL_WIDTH);
        end
    end

    // Конкатенация: сначала нули (если остаётся место), потом данные
    assign sts_bus = {
        {(TOTAL_WIDTH - FIELDS_WIDTH){1'b0}}, // padding до TOTAL_WIDTH
        cur_adc_b,          // 10
        cur_adc_a,          // 9
        samples_count,      // [8]
        triggers_count,     // [7]
        trigger_activated,  // [6]
        adc_sent,           // [5]
        first_trgged,       // [4]
        last_detrigged,     // [3]
        cur_adc,            // [2]
        adc_abs_max,        // [1]
        rx_cntr             // [0]
    };

endmodule
