module dis(an,clk,number,seg,rst);
    output reg [7:0] an;
    input [31:0] number;
    output [0:6] seg;
    input rst;
    reg [7:0] th;
    input clk;
    reg [31:0] num=0;
    wire [4:0] temp;
    wire [7:0] tempConv;
    wire[1:0] alert;
    wire o_DV;
    reg start=1'b1;

    reg[2:0] count =0;
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
                3'd0: begin th <= num[3:0]; an <= 8'b11110111; end
                3'd1: begin th <= num[7:4]; an <= 8'b11111011; end
                3'd2: begin th <= num[11:8]; an <= 8'b11111101; end
                3'd3: begin th <= num[15:12]; an <= 8'b11111110; end
                3'd4: begin th <= num[19:16]; an <= 8'b11101111; end
                3'd5: begin th <= num[23:20]; an <= 8'b11011111; end
                3'd6: begin th <= num[27:24]; an <= 8'b10111111; end
                3'd7: begin th <= num[31:28]; an <= 8'b01111111; end
            endcase
        end else begin
            count<= 0; 
        end
    end

endmodule