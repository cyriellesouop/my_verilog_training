`timescale 1ns/1ps

module testbench;

	parameter PERIOD = 4;
	parameter ADDRESS_WIDTH = 4;
	parameter DATA_WIDTH = 8;

	reg clk = 0;

	reg WR; 
        reg [ADDRESS_WIDTH-1:0] wraddr;
	reg [(DATA_WIDTH-1):0]  dataIn;
	
	reg RD;
	reg [ADDRESS_WIDTH-1:0] rdaddr;
	wire [(DATA_WIDTH-1):0] dataOut;	

	always #(PERIOD/2) clk = ~clk;

	top #(
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
		wraddr = 4'hA;
		rdaddr =4'hA;
		dataIn =8'h0E; 

		#PERIOD;
	       	WR = 1;
	       	
		#PERIOD;
		WR = 0;
		RD = 1;
		
		#PERIOD;
		wraddr = 4'b0000;
		dataIn =8'hAE;
		RD = 0;
		WR = 1;
		#PERIOD;
		rdaddr =4'h0;
		RD = 1;
		#PERIOD;
		RD = 0;
		#PERIOD; 
		RD = 1;
		
		#PERIOD;
		$finish;

	 end

	 initial begin
		 $monitor ("\n [%0t] RD=%b rdaddr=%0d dataOut=%0d ", $time, RD, rdaddr, dataOut);

		 $monitor ("\n [%0t] WR=%b wraddr=%0d dataIn=%0d", $time, WR, wraddr, dataIn);
	 end
	

	endmodule

