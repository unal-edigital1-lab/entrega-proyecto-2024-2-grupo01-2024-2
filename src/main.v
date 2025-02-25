module main (clk,reset,echo,trigger,an,seg, enable);
    input clk;
    input reset;
    input echo;             
    output trigger;
    output [3:0] an;
    output [0:6] seg;
    input enable;
    wire [15:0] true_cm;
    reg [3:0] estados;
    reg [5:0] tiempo=0;
    reg [25:0] contador =0;
    reg odio =0;

    ultrasonic ultra(.clk(clk),.reset(reset),.echo(echo),.trigger(trigger),.an(an),.seg(seg),.enable(enable),.true_cm(true_cm));

    always @(posedge clk or posedge reset) begin
        if (reset==1) begin
            tiempo<=0;
            contador=0;
        end else begin
            if (contador >= 50000000) begin
                contador <= 0;
                tiempo<=tiempo+1;
            end
            if (tiempo>=60) begin
                odio=1;
            end
            if(enable==1||true_cm<=5) begin
                odio=0;
            end
        end
    end

endmodule