`timescale 1 ns / 1 ps

module tb_adc();

    // Параметры
    localparam ADC_DATA_WIDTH = 14;

    // Сигналы
    reg clk;
    reg rstn;

    reg  [15:0] adc_dat_a;
    reg  [15:0] adc_dat_b;

    reg  [7:0]  limiter;
    reg  [15:0] trigger_level;
    reg         reset_trigger;
    reg         reset_max_sum;

    wire        adc_csn;
    wire [15:0] cur_adc;
    wire [63:0] cur_sample;

    wire        m_axis_tvalid;
    wire        m_axis_tlast;
    wire [31:0] m_axis_tdata;

    wire signed [15:0] max_sum_out;
    wire [63:0] last_detrigged;
    wire [63:0] first_trigged;
    wire [63:0] cur_limiter;
    wire [31:0] samples_sent;
    wire trigger_activated;
    wire [15:0] triggers_count;

    // DUT
    ADC #(
        .ADC_DATA_WIDTH(ADC_DATA_WIDTH)
    ) dut (
        .aclk(clk),
        .aresetn(rstn),

        .adc_csn(adc_csn),
        .adc_dat_a(adc_dat_a),
        .adc_dat_b(adc_dat_b),

        .cur_adc(cur_adc),
        .cur_sample(cur_sample),
        
        .limiter(limiter),

        .trigger_level(trigger_level),
        .reset_trigger(reset_trigger),
        .reset_max_sum(reset_max_sum),

        .m_axis_tvalid(m_axis_tvalid),
        .m_axis_tlast(m_axis_tlast),
        .m_axis_tdata(m_axis_tdata),

        .max_sum_out(max_sum_out),
        .last_detrigged(last_detrigged),
        .first_trigged(first_trigged),
        .cur_limiter(cur_limiter),
        .samples_sent(samples_sent),
        .trigger_activated(trigger_activated),
        .triggers_count(triggers_count)
    );

    // Тактовый генератор
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 100 МГц
    end

    // Тест
    initial begin
        // init
        rstn            = 0;
        limiter         = 8'd8;           // = 2^2 = 4 отсчета 5->32
        adc_dat_a       = 16'd10;
        adc_dat_b       = 16'd2;
        trigger_level   = 16'd20;
        reset_trigger   = 0; 
        reset_max_sum   = 0;

        #10;
        rstn        = 1;

        // Активируем триггер
        #10;
        reset_trigger = 1;
        
        
        #5;
        
        // Генерация данных для обоих каналов (350-600)
        repeat (632) begin
            @(posedge clk);
            if (adc_dat_a >= 16'd40) begin
                adc_dat_a <= 16'd3;
                adc_dat_b <= 16'd5;
                #4;
            end else begin
                adc_dat_a <= adc_dat_a + 1;
                adc_dat_b <= adc_dat_b + 1;  // канал B чуть быстрее
                #4;
            end
        end

        #100;
        $stop;
    end

    // Мониторинг
    always @(posedge clk) begin
        if (m_axis_tvalid) begin
            $display("time=%0t : data=%h, tlast=%b", $time, m_axis_tdata, m_axis_tlast);
        end
    end

endmodule
