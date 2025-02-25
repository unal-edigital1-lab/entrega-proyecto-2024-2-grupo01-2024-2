module ultrasonic(clk,reset,echo,trigger,an,seg, enable);
    input clk;
    input reset;
    input echo;             
    output reg trigger=0;
    reg [0:15] cm=0;
    output [3:0] an;
    output [0:6] seg;
    reg [21:0] counter;
    reg [11:0] cm_cont;
    input enable;
    reg last=0;

    dis Dis(.an(an),.clk(clk),.number(cm),.seg(seg),.rst(reset));

    always @(posedge clk or posedge reset) begin
        if (reset==1) begin
            counter <= 0;
            trigger <= 0;
            cm_cont <=0;
            cm<=0; 
        end else begin
            counter <= counter + 1;
            cm_cont<=cm_cont+1;
            if (last!=echo) begin
                counter <= 0;
                cm_cont <=0;
            end
            if (cm_cont>=2900 && enable==1 && echo==1) begin
                cm_cont<=0;
                cm<=cm+1;
            end
            // *Generación del pulso de Trigger (10 µs mínimo)*
            if (counter < 500) begin  // 10 µs con clk de 50 MHz
                trigger <= 1;
            end else if (counter < 1000) begin
                trigger <= 0;
            end 

            // Reiniciar el ciclo cada 50 ms (~2,500,000 ciclos a 50 MHz)
            if (counter >= 5000000) begin
                counter <= 0;
            end
            last<=echo;
        end
    end
endmodule