`timescale 1ns/1ps

module memory
	
	#(parameter ADDRESS_WIDTH = 8,
	  parameter DATA_WIDTH = 32 )
	(
	input   RD,
	input   WR,
	input clk,
	input [ADDRESS_WIDTH-1:0] wraddr,
	input [ADDRESS_WIDTH-1:0] rdaddr,
	input [(DATA_WIDTH-1):0]  dataIn,
       output reg [(DATA_WIDTH-1):0] dataOut);

	reg [DATA_WIDTH-1:0] word [0:(2**ADDRESS_WIDTH)-1];
	always @(posedge clk) begin
		
		if (WR)
			word[wraddr] <= dataIn;
		
		if(RD)
			dataOut <= word[rdaddr];

		
	end

	
endmodule 
