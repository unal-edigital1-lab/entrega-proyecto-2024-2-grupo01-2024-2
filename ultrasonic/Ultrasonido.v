module Ultrasonido(
    input clk,            // Reloj del sistema (Ej: 50MHz)
    output reg trig,      // Señal de activación del sensor
    input echo,           // Señal de respuesta del sensor
    output reg [15:0] distancia_cm  // Distancia medida en cm
);

    reg [19:0] contador_us = 0;   // Contador para generar el pulso Trig
    reg [19:0] tiempo_echo = 0;   // Tiempo que Echo está en alto (en ciclos de reloj)
    reg midiendo = 0;             // Estado de medición

    // Parámetro para calcular la distancia (asume reloj de 50 MHz)
    parameter CLOCK_FREQ = 50000000; // 50 MHz
    parameter TICK_1US = CLOCK_FREQ / 1000000; // Cuántos ciclos son 1us

    always @(posedge clk) begin
        // Generar pulso Trig de 10us cada cierto tiempo
        if (contador_us < TICK_1US * 10) begin
            trig <= 1;
            contador_us <= contador_us + 1;
        end else if (contador_us < TICK_1US * 60000) begin
            trig <= 0; // Apagar Trig
            contador_us <= contador_us + 1;
        end else begin
            contador_us <= 0; // Reiniciar el ciclo
        end

        // Medir tiempo en el que Echo está en alto
        if (echo) begin
            midiendo <= 1;
            tiempo_echo <= tiempo_echo + 1;
        end else if (midiendo) begin
            midiendo <= 0;
            // Calcular distancia en cm
            distancia_cm <= (tiempo_echo * 34300) / (2 * TICK_1US);
            tiempo_echo <= 0;
        end
    end
endmodule