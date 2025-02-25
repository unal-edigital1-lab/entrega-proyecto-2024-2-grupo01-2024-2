`include "src\spi_master.v"

module fsm_matriz8x8 (
    input clk,                // Reloj del sistema
    input reset,              // Señal de reset
    input [1:0] state,        // Selector de patrones de LED
    output mosi,              // Master Out Slave In (Din)
    output sclk,              // Reloj SPI
    output cs                 // Chip Select
);

    reg [7:0] data_in;
    wire [7:0] data_out;

    reg start;
    wire busy;
    wire avail;

    wire [25:0] div_factor = 25000000;  // Factor de división fijo

    spi_master spi (
        .clk(clk),
        .reset(~reset),
        .data_in(data_in),
        .start(start),
        .div_factor(div_factor),
        .mosi(mosi),
        .sclk(sclk),
        .cs(cs),
        .data_out(data_out),
        .busy(busy),
        .avail(avail)
    );

    // Memorias para diferentes patrones de LEDs
    reg [7:0] patron1 [0:7];  // Patrón 1
    reg [7:0] patron2 [0:7];  // Patrón 2
    reg [7:0] patron3 [0:7];  // Patrón 3
    reg [7:0] patron4 [0:7];  // Patrón 4

    reg [7:0] memory4CommandSend [0:15]; // Buffer de datos a enviar

    reg [5:0] mem_index = 0;
    reg sendByte;
    reg [10:0] state_send = 0;
    reg [1:0] prev_state = 2'b00;  // Para detectar cambios en el estado externo

    // Inicialización de patrones
    initial begin
        // Patrón 1 - Feliz
        patron1[0] = 8'b11111111;
        patron1[1] = 8'b10000001;
        patron1[2] = 8'b10100101;
        patron1[3] = 8'b10000001;
        patron1[4] = 8'b10100101;
        patron1[5] = 8'b10011001;
        patron1[6] = 8'b10000001;
        patron1[7] = 8'b11111111;

        // Patrón 2 - Triste
        patron2[0] = 8'b11111111;
        patron2[1] = 8'b10000001;
        patron2[2] = 8'b10100101;
        patron2[3] = 8'b10000001;
        patron2[4] = 8'b10011001;
        patron2[5] = 8'b10100101;
        patron2[6] = 8'b10000001;
        patron2[7] = 8'b11111111;

        // Patrón 3 - Enojado
        patron3[0] = 8'b11111111;
        patron3[1] = 8'b11000011;
        patron3[2] = 8'b10100101;
        patron3[3] = 8'b10100101;
        patron3[4] = 8'b10000001;
        patron3[5] = 8'b10011001;
        patron3[6] = 8'b10100101;
        patron3[7] = 8'b11111111;

        // Patrón 4 - Dormido
        patron4[0] = 8'b11111111;
        patron4[1] = 8'b10000001;
        patron4[2] = 8'b10000001;
        patron4[3] = 8'b11100111;
        patron4[4] = 8'b10000001;
        patron4[5] = 8'b10011001;
        patron4[6] = 8'b10011001;
        patron4[7] = 8'b11111111;
    end

    // Detectar cambios en `state` y actualizar `memory4CommandSend`
    always @(posedge clk) begin
        if (reset) begin
            prev_state <= state; // Almacena el estado actual
            case (state)
                2'b00: memory4CommandSend = {patron1[0], patron1[1], patron1[2], patron1[3], patron1[4], patron1[5], patron1[6], patron1[7]};
                2'b01: memory4CommandSend = {patron2[0], patron2[1], patron2[2], patron2[3], patron2[4], patron2[5], patron2[6], patron2[7]};
                2'b10: memory4CommandSend = {patron3[0], patron3[1], patron3[2], patron3[3], patron3[4], patron3[5], patron3[6], patron3[7]};
                2'b11: memory4CommandSend = {patron4[0], patron4[1], patron4[2], patron4[3], patron4[4], patron4[5], patron4[6], patron4[7]};
            endcase
            mem_index <= 0;
        end
    end

    // Máquina de estados para transmisión SPI
    always @(posedge clk) begin
        if (~reset) begin
            state_send <= 0;
            sendByte <= 0;
            mem_index <= 0;
        end else begin
            case (state_send)
                0: begin
                    data_in <= memory4CommandSend[mem_index]; 
                    sendByte <= 1; 
                    state_send <= 1;
                end
                1: begin
                    state_send <= 2;
                end
                2: begin
                    sendByte <= 0; 
                    if (avail) begin
                        state_send <= 0;    
                        mem_index <= mem_index + 1;
                        if (mem_index > 7) begin
                            mem_index <= 0;    
                            state_send <= 3;    
                        end
                    end
                end
                3: begin 
                    mem_index <= 0;            
                end 
            endcase
        end
    end

    // Envío de un byte por SPI
    always @(negedge clk) begin
        if (~reset) begin
            start <= 0;
        end else begin
            case (start)
                0: begin  // IDLE
                    if (!busy && sendByte) begin
                        start <= 1;
                    end
                end
                1: begin  // SEND
                    if (avail) begin
                        start <= 0;
                    end
                end
            endcase
        end
    end
endmodule