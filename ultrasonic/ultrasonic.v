module ultrasonic(
    input clk,               // Reloj de 50 MHz del FPGA
    input reset,             // Reset para reiniciar el sistema
    input echo,              // Señal de retorno del sensor
    output reg trigger,      // Señal de activación del sensor
    output reg [15:0] dist   // Distancia medida en cm
);

    reg [31:0] counter;      // Contador general para control del trigger
    reg [31:0] echo_time;    // Contador para medir la duración del pulso de echo
    reg echo_last;           // Registro para detectar flancos en la señal echo
    reg measuring;           // Bandera para indicar si estamos midiendo echo

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            counter <= 0;
            trigger <= 0;
            echo_time <= 0;
            dist <= 0;
            echo_last <= 0;
            measuring <= 0;
        end else begin
            // *Generación del pulso de Trigger (10 µs mínimo)*
            if (counter < 500) begin  // 10 µs con clk de 50 MHz
                trigger <= 1;
            end else if (counter < 1000) begin
                trigger <= 0;
            end 

            // Reiniciar el ciclo cada 50 ms (~2,500,000 ciclos a 50 MHz)
            if (counter >= 2500000) begin
                counter <= 0;
            end else begin
                counter <= counter + 1;
            end

            // *Detección de flancos en Echo*
            echo_last <= echo;  // Guardar estado anterior del Echo

            if (echo == 1 && echo_last == 0) begin
                // *Inicio del pulso de Echo (flanco de subida)*
                measuring <= 1;
                echo_time <= 0;  // Reiniciar el contador
            end else if (echo == 0 && echo_last == 1) begin
                // *Fin del pulso de Echo (flanco de bajada)*
                measuring <= 0;
                dist <= echo_time / 2900; // Conversión directa a cm
            end 

            // *Contar el tiempo mientras Echo esté en alto*
            if (measuring) begin
                echo_time <= echo_time + 1;
            end
        end
    end

endmodule