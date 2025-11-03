`timescale 1ns/1ps

module testbench;

	reg clk=0;
	reg [7:0] addrIn;
        reg [7:0] addrOut;
	reg [1:0] RD;
        reg [1:0] WR;
        reg [31:0]  dataIn;
       	wire [31:0] dataOut;
	
	always #2 clk = ~clk;
	memory DUT(RD,WR, clk, addrIn, addrOut, dataIn, dataOut);
	
	initial begin
		
		RD = 2'b00;
		WR = 2'b00;
		addrIn = 8'hDA;
		dataIn = 32'h0000AAAA;
		addrOut = 8'hDA;
		
		#4 WR = 2'b01;
		RD = 2'b01;

                #4;
		
		#4 addrOut =8'hA;
		
	#10;
	$finish;

	 end
	 
	 initial begin
		 $monitor ("\n [monitor read]  [%0t] RD=0x%0d addrOut=0x%0h dataOut=0x%0h ", $time, RD, addrOut, dataOut);

		 $monitor ("\n [monitor write]  [%0t] WR=0x%0d addrIn=0x%0h dataIn=0x%0h ", $time, WR, addrIn, dataIn);
	 end

endmodule
