module axis_cfg_interface (
    input wire clk,
    input wire aresetn,  // Активный низкий сигнал сброса

    // AXI4-Stream Slave Interface
    input wire [31:0] s_axis_tdata,
    input wire s_axis_tvalid,
    output wire s_axis_tready,

    // AXI4-Stream Master Interface
    output reg [31:0] m_axis_tdata,
    output reg m_axis_tvalid,
    input wire m_axis_tready,

    // Configuration register outputs
    output reg [159:0] cfg,
    input wire [31:0] cfg_out
);

    reg [159:0] cfg_reg;
    reg [2:0] word_counter;

    // Slave interface logic (прием данных)
    always @(posedge clk) begin
        if (!aresetn) begin
            cfg_reg <= 160'b0;
            word_counter <= 3'b000;
        end else if (s_axis_tvalid && s_axis_tready) begin
            // Запись данных в 160-битный регистр cfg по словам
            case (word_counter)
                3'b000: cfg_reg[31:0] <= s_axis_tdata;
                3'b001: cfg_reg[63:32] <= s_axis_tdata;
                3'b010: cfg_reg[95:64] <= s_axis_tdata;
                3'b011: cfg_reg[127:96] <= s_axis_tdata;
                3'b100: cfg_reg[159:128] <= s_axis_tdata;
            endcase

            // Увеличение счетчика слов
            if (word_counter == 3'b100) begin
                word_counter <= 3'b000;
            end else begin
                word_counter <= word_counter + 1;
            end
        end
    end

    // Передача данных в master интерфейс
    always @(posedge clk) begin
        if (!aresetn) begin
            m_axis_tdata <= 32'b0;
            m_axis_tvalid <= 0;
        end else if (m_axis_tready) begin
            // Отправка cfg_out, когда master готов принять данные
            m_axis_tdata <= cfg_out;
            m_axis_tvalid <= 1;
        end else begin
            m_axis_tvalid <= 0;
        end
    end

    // Output assignments
    assign s_axis_tready = (word_counter != 3'b100); // Готовность принимать данные, пока счетчик слов не достиг 5

    // Register output
    always @(posedge clk or negedge aresetn) begin
        if (!aresetn) begin
            cfg <= 160'b0;
        end else begin
            cfg <= cfg_reg;
        end
    end

endmodule
