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
		wraddr = 4'h0;
		rdaddr =4'h0;
		dataIn =8'h0E; 

		@(posedge clk);
	       	WR = 1;
	       @(posedge clk);
	       	WR = 0;
		
		@(posedge clk);
		RD = 1;
		repeat (3) @(posedge clk);

		
		RD = 0;
		@(posedge clk);


		wraddr = 4'h5;
                rdaddr =4'h5;
                dataIn =8'hEE;
		@(posedge clk);
                WR = 1;
               @(posedge clk);
                WR = 0;

                @(posedge clk);
                RD = 1;
                repeat (3) @(posedge clk);

                RD = 0;
		@(posedge clk);


                wraddr = 4'hF;
                rdaddr =4'hF;
                dataIn =8'h00;
                @(posedge clk);
                WR = 1;
               @(posedge clk);
                WR = 0;
                @(posedge clk);
                RD = 1;
                repeat (3) @(posedge clk);

                RD = 0;

		@(posedge clk);


                wraddr = 4'hB;
                rdaddr =4'hB;
                dataIn =8'hFF;
                @(posedge clk);
                WR = 1;
               @(posedge clk);
                WR = 0;
                @(posedge clk);
                RD = 1;
                
		#1000;
		$finish;

	 end

	 initial begin
		 $monitor ("\n [%0t] RD=%b   rdaddr=%0d dataOut=%0d ", $time, RD, rdaddr, dataOut);

		 $monitor ("\n [%0t] WR=%b   wraddr=%0d dataIn=%0d", $time, WR, wraddr, dataIn);
	 end
	

	endmodule
