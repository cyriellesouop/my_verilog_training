`timescale 1ns/1ps

module memory
	
	#(parameter ADDRESS_WIDTH = 8,
	  parameter DATA_WIDTH = 32 )
	(
	input   RD,
	input   WR,
	input clk,
	input rstn,
	input [ADDRESS_WIDTH-1:0] wraddr,
	input [ADDRESS_WIDTH-1:0] rdaddr,
	input [(DATA_WIDTH-1):0]  dataIn,
       output reg [(DATA_WIDTH-1):0] dataOut);
       

	reg [DATA_WIDTH-1:0] word [0:(2**ADDRESS_WIDTH)-1];
	reg [2**ADDRESS_WIDTH-1 : 0] i;
	//reg word_changed;
	always @(posedge clk) begin

	   if (!rstn) begin
	   dataOut <= 0;
	  // word_changed <=0;
		for(i = 0; i< (2**ADDRESS_WIDTH); i = i+1)
			word[i] = {DATA_WIDTH{1'b0}};
			
       end
	   else begin
	   
		//word_changed <=0;
		if (WR)
		   begin
			word[wraddr] <= dataIn;
		//	word_changed <= ~word_changed;
			end
		
		if(RD)
			dataOut <= word[rdaddr];

	  end

		
	end

	
endmodule 
