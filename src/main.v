module main (clk,reset,echo,trigger,an,seg, enable,mosi,sclk,cs,act);
    input clk;
    input reset;
    input echo;             
    output trigger;
    output [7:0] an;
    output [0:6] seg;
    input enable;
    wire [15:0] true_cm;
    reg [0:11] tiempo=0;
    reg [26:0] contador =0;
    reg [3:0] state =1;
    reg hambre=0;
    output mosi;
    output sclk;
    output cs;
    input [1:0] act;
    reg stop=0;

    ultrasonic ultra(.clk(clk),.reset(reset),.echo(echo),.trigger(trigger),.an(an),.seg(seg),.enable(enable),.true_cm(true_cm),.otros({tiempo,state}),.stop(stop));
    matriz_caras3 caras(.clk(clk),.reset(reset),.state(state),.mosi(mosi),.sclk(sclk),.cs(cs));

    always @(posedge clk or posedge reset) begin
        if (reset==1) begin
            tiempo<=0;
            contador<=0;
            state<=0;
        end else begin
            contador<=contador+1;
            if (contador >= 50000000) begin
                contador <= 0;
                tiempo<=tiempo+1;
            end
            if (tiempo>=30) begin
                state<=1;
                tiempo<=0;
                stop<=0;
            end else if(enable==0 && true_cm<=5 && stop==0  && state==1) begin
                tiempo<=0;
                state<=2;
                stop<=1;
            end else if (act[0]==1 && state==2 && enable==1) begin
                state<=3;
                stop<=0;
            end else if(act[1]==1 && state==3 && enable==1)begin
                state<=0;
                stop<=0;
            end
        end
    end

endmodule