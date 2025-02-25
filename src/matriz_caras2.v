//`include "src\spi_master.v"

module matriz_caras2 (
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
    reg [7:0] patron1 [7:0];  // Patrón 1
    reg [7:0] patron2 [7:0];  // Patrón 2
    reg [7:0] patron3 [7:0];  // Patrón 3
    reg [7:0] patron4 [7:0];  // Patrón 4

    reg [4:0] memory4CommandSend [17:0]; // Buffer de datos a enviar

    reg [5:0] mem_index = 0;
    reg sendByte;
    reg [10:0] state_send = 0;
    reg [1:0] prev_state = 2'b00;  // Para detectar cambios en el estado externo

    // Inicialización de patrones
    initial begin
        
        //Boot Matriz
        memory4CommandSend[0] = 8'h0C;  // Shutdown command
        memory4CommandSend[1] = 8'h01;  // Shutdown Normal Operation
        memory4CommandSend[2] = 8'h09;  // Decode-Mode
        memory4CommandSend[3] = 8'h00;  // Decode-Mode No decode for digits 7–0
		  memory4CommandSend[4] = 8'h0A;  // Intensity
		  memory4CommandSend[5] = 8'h0A;  // Intensity value
        memory4CommandSend[6] = 8'h0B;  // Scan Limit
        memory4CommandSend[7] = 8'h07;  // Scan Limit Value
		  memory4CommandSend[8] = 8'h0F;  // Display Test 
        memory4CommandSend[9] = 8'h00;  // Display Test Value

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
                2'b00: begin
                    memory4CommandSend[10]  = patron1[0];
                    memory4CommandSend[11]  = patron1[1] ;
                    memory4CommandSend[12]  = patron1[2] ;
                    memory4CommandSend[13]  = patron1[3] ;
                    memory4CommandSend[14]  = patron1[4] ;
                    memory4CommandSend[15]  = patron1[5] ;
                    memory4CommandSend[16]  = patron1[6] ;
                    memory4CommandSend[17]  = patron1[7] ;

                end
                2'b01: begin
                    memory4CommandSend[10]  = patron2[0];
                    memory4CommandSend[11]  = patron2[1] ;
                    memory4CommandSend[12]  = patron2[2] ;
                    memory4CommandSend[13]  = patron2[3] ;
                    memory4CommandSend[14]  = patron2[4] ;
                    memory4CommandSend[15]  = patron2[5] ;
                    memory4CommandSend[16]  = patron2[6] ;
                    memory4CommandSend[17]  = patron2[7] ;

                end
                2'b10: begin
                    memory4CommandSend[10]  = patron3[0];
                    memory4CommandSend[11]  = patron3[1] ;
                    memory4CommandSend[12]  = patron3[2] ;
                    memory4CommandSend[13]  = patron3[3] ;
                    memory4CommandSend[14]  = patron3[4] ;
                    memory4CommandSend[15]  = patron3[5] ;
                    memory4CommandSend[16]  = patron3[6] ;
                    memory4CommandSend[17]  = patron3[7] ;

                end
            
                2'b11: begin
                    memory4CommandSend[10]  = patron4[0];
                    memory4CommandSend[11]  = patron4[1] ;
                    memory4CommandSend[12]  = patron4[2] ;
                    memory4CommandSend[13]  = patron4[3] ;
                    memory4CommandSend[14]  = patron4[4] ;
                    memory4CommandSend[15]  = patron4[5] ;
                    memory4CommandSend[16]  = patron4[6] ;
                    memory4CommandSend[17]  = patron4[7] ;

                end
                
            endcase
        
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