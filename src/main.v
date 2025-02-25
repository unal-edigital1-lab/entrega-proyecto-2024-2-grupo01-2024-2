module main (clk,reset,echo,trigger,an,seg, enable);
    input clk;
    input reset;
    input echo;             
    output trigger;
    output [3:0] an;
    output [0:6] seg;
    input enable;
    reg [15:0] cm;
    reg [3:0] estados;
    reg [5:0] tiempo=0;
    reg [25:0] contador =0;

    ultrasonic ultra(.clk(clk),.reset(reset),.echo(echo),.trigger(trigger),.an(an),.seg(seg),.enable(enable),.cm(cm));

    always @(posedge clk or posedge reset) begin
        if (reset==1) begin
            tiempo<=0;
            contador=0;
        end else begin
            if (contador >= 50000000) begin
                contador <= 0;
                tiempo<=tiempo+1;
            end
        end
    end

endmodule