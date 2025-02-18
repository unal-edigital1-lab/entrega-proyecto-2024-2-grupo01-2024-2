module ultrasonic(
    input clk,               // Reloj de 50 MHz del FPGA
    input reset,             // Reset para reiniciar el sistema
    input echo,              // Señal de retorno del sensor
    output trigger=0,      // Señal de activación del sensor
    output [11:0] cm=0,
    an,seg
);

    output reg [3:0] an;
    output [0:6] seg;
    reg [21:0] counter=0;      // Contador general para control del trigger
    reg [11:0] cm_cont=0;
    reg enable=0;

    dis Dis(.an(an),.clk(clk),.seg(seg),.rst(reset));

    always @(posedge echo) begin
        cm_cont<=0;
        cm<=0;
        enable<=1;
    end

    always @(negedge echo) begin
        enable=0;
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            counter <= 0;
            trigger <= 0;
            cm_cont <=0;
            enable <=0;
        end else begin
            counter <= counter + 1;
            cm_cont<=cm_cont+1;
            if (cm_cont>=2900&&enable==1) begin
                cm_cont=0;
                cm<=cm+1;
            end
            // *Generación del pulso de Trigger (10 µs mínimo)*
            if (counter < 500) begin  // 10 µs con clk de 50 MHz
                trigger <= 1;
            end else if (counter < 1000) begin
                trigger <= 0;
            end 

            // Reiniciar el ciclo cada 50 ms (~2,500,000 ciclos a 50 MHz)
            if (counter >= 3000000) begin
                counter <= 0;
            end
        end
    end
endmodule