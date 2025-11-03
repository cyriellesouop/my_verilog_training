`timescale 1ns/1ps

module tb_mem;

	parameter PERIOD = 4;
	parameter ADDRESS_WIDTH = 4;
	parameter DATA_WIDTH = 16;

	reg clk = 0;

	reg WR; 
        reg [ADDRESS_WIDTH-1:0] wraddr;
	reg [(DATA_WIDTH-1):0]  dataIn;
	
	reg RD;
	reg [ADDRESS_WIDTH-1:0] rdaddr;
	wire [(DATA_WIDTH-1):0] dataOut;	

	always #(PERIOD/2) clk = ~clk;

	memory #(
		.ADDRESS_WIDTH(ADDRESS_WIDTH), 
		.DATA_WIDTH(DATA_WIDTH) ) 

	DUT ( 
		.clk(clk),
		.WR(WR),
		.wraddr(wraddr),
		.dataIn(dataIn),

		.RD(RD),
      		.rdaddr(rdaddr ),
		.dataOut(dataOut)	
	);

	initial begin

		WR = 0;
		RD = 0;
		wraddr = 4'hB;
		dataIn =16'hAAAA; 

		#PERIOD;
	       	WR = 1;
		#PERIOD;
	
		rdaddr =4'hB;
		RD = 1;
		#PERIOD;
		$finish;

	 end

	 initial begin
		 $monitor ("\n [%0t] RD=%b rdaddr=%0d dataOut=%0d ", $time, RD, rdaddr, dataOut);

		 $monitor ("\n [%0t] WR=%b wraddr=%0d dataIn=%0d", $time, WR, wraddr, dataIn);
	 end
	

	endmodule

