module ultrasonic(clk,reset,echo,trigger,an,seg,enable,true_cm,otros,stop);
    input clk;
    input reset;
    input echo;             
    output reg trigger;
    reg [15:0] cm;
    output [7:0] an;
    output [0:6] seg;
    reg [23:0] counter;
    reg [11:0] cm_cont;
    input enable;
    output reg [15:0] true_cm=0;
    input [15:0] otros;

    dis Dis(.an(an),.clk(clk),.number({otros,true_cm}),.seg(seg),.rst(reset));

    always @(posedge clk or posedge reset) begin
        if (reset==1) begin
            counter <= 0;
            trigger <= 0;
            cm_cont <=0;
            cm<=0; 
        end else begin
            counter <= counter + 1;
            cm_cont<=cm_cont+1;
            if (cm_cont>=2900 && enable==1 && echo==1) begin
                cm_cont<=0;
                cm<=cm+1;
                true_cm<=cm;
            end
            // *Generación del pulso de Trigger (10 µs mínimo)*
            if (counter < 500) begin  // 10 µs con clk de 50 MHz
                trigger <= 1;
            end else if (counter < 1000) begin
                trigger <= 0;
            end 

            // Reiniciar el ciclo cada 100 ms (~5,000,000 ciclos a 50 MHz)
            if (counter >= 5000000) begin
                counter <= 0;
                cm_cont <=0;
                cm<=0;
            end
            if (stop) begin
                true_cm<=0;
            end
        end
    end
endmodule