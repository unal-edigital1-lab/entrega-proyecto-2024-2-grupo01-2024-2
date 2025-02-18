module BCDtoSSeg (BCD, SSeg);

  input [3:0] BCD;
  output reg [0:6] SSeg; // se puede definir de 0 a 6, o de 6 a 0, cambiando posición del bit más significativo

  always @ ( * ) begin
    case (BCD)
    4'b0000: SSeg = 7'b0000001; // "0"  
    4'b0001: SSeg = 7'b1001111; // "1" 
    4'b0010: SSeg = 7'b0010010; // "2" 
    4'b0011: SSeg = 7'b0000110; // "3" 
    4'b0100: SSeg = 7'b1001100; // "4" 
    4'b0101: SSeg = 7'b0100100; // "5" 
    4'b0110: SSeg = 7'b0100000; // "6" 
    4'b0111: SSeg = 7'b0001111; // "7" 
    4'b1000: SSeg = 7'b0000000; // "8"  
    4'b1001: SSeg = 7'b0000100; // "9" 
    4'b1010: SSeg = 7'b0001000; //a
    4'b1011: SSeg = 7'b1100000; //b
    4'b1100: SSeg = 7'b0110001; //c
    4'b1101: SSeg = 7'b1000010; //d
    4'b1110: SSeg = 7'b0110000; //e
    4'd15: SSeg = 7'b0111000; //f
      default:
      SSeg = 0;
    endcase
  end

endmodule
