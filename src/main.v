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
    reg [3:0] state =0;
    reg hambre=0;
    output mosi;
    output sclk;
    output cs;
    input [2:0] act;

    ultrasonic ultra(.clk(clk),.reset(reset),.echo(echo),.trigger(trigger),.an(an),.seg(seg),.enable(enable),.true_cm(true_cm),.otros({tiempo,state}));
    //matriz_caras2 caras(.clk(clk),.reset(reset),.state(state),.mosi(mosi),.sclk(sclk),.cs(cs));

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
            if (tiempo>=60) begin
                state=1;
                tiempo<=0;
            end else if(enable==1 && true_cm<=5 && act[2]==1 ) begin
                tiempo<=0;
                state<=2;
            end else if (act[0]==1 && state==2) begin
                state<=3;
            end else if(act[1]==1 && state==3)begin
                state<=0;
            end
        end
    end

endmodule