module dis(an,clk,number,seg,rst);
    output reg [3:0] an;
    input [15:0] number;
    output [0:6] seg;
    input rst;
    reg [3:0] th;
    input clk;
    reg [15:0] num=0;
    wire [4:0] temp;
    wire [7:0] tempConv;
    wire[1:0] alert;
    wire o_DV;
    reg start=1'b1;

    reg[1:0] count =0;
    reg [26:0] fre;
    wire enable;
    assign enable =fre[16];
    reg [2:0] test=0; 

    BCDtoSSeg bcd(.BCD(th),.SSeg(seg));
    //sum4bcc sumar(.xi(number[3:0]),.yi(number[7:4]),.co(temp[4]),.zi(temp[3:0]),.alt(alert));
    //Binary_to_BCD#(.INPUT_WIDTH(5),.DECIMAL_DIGITS(2)) conv(.i_Clock(clk),.i_Binary(temp),.i_Start(start),.o_BCD(tempConv),.o_DV(o_DV));

    always @(posedge clk) begin
        if(rst==1) begin
                fre <= 0;
            end else begin
                fre <=fre+1;
        end
    end

    always @(posedge enable) begin
        if(rst==0) begin
            count<= count+1;
            num<=number;
            case (count)
                2'd0: begin th <= num[3:0]; an <= 4'b0111; end
                2'd1: begin th <= num[7:4]; an <= 4'b1011; end
                2'd2: begin th <= num[11:8]; an <= 4'b1101; end
                2'd3: begin th <= num[15:12]; an <= 4'b1110; end
            endcase
        end else begin
            count<= 0; 
        end
    end

endmodule