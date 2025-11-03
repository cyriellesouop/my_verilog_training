`timescale 1ns/1ps

module memory(
	input  [1:0] RD,
	input  [1:0] WR,
	input clk,
	input [7:0] addrIn,
	input [7:0] addrOut,
	input [31:0]  dataIn,
       output reg [31:0] dataOut);

	reg [31:0] word [0:255];
	always @(posedge clk) begin
		
		if (WR == 2'b01)
			word[addrIn] <= dataIn;
		else if (WR == 2'b00)
                        word[addrIn] <= 32'hxxxxxxxx;
		if(RD == 2'b01)
			dataOut <= word[addrOut];
		else  if (RD == 2'b00)
                        dataOut <= 32'hxxxxxxxx;

		
	end

	
endmodule 
