`timescale 1ns/1ps

module segCtrl

#(parameter DATA_WIDTH =3 ,
  parameter RESULT_WIDTH = 7)

  (
  input [DATA_WIDTH-1 : 0] dataIn,
  output reg  [RESULT_WIDTH-1 : 0 ] dataOut
  
  );

  always @(*) begin
	case(dataIn)
		0: dataOut <= 7'b1000000;
		1: dataOut <= 7'b1111001;
	        2: dataOut <= 7'b0100100 ;
		3: dataOut <= 7'b0110000;
		4: dataOut <= 7'b0011001;
	        5: dataOut <= 7'b0010010;
		6: dataOut <= 7'b0000010;
		7: dataOut <= 7'b1111000;	

		default: dataOut <= 7'b1111111;	
	endcase
  end

endmodule

