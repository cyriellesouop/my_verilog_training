`timescale 1ns/1ps

module testbench;

    reg clk1 = 0;
    reg clk2 = 0;
    reg clk3 = 0;
    reg [2:0] addrIn1;
    reg [2:0] addrIn2;
    reg [63:0] dataIn1;
    reg [63:0] dataIn2;
    reg WR1 ;
    reg WR2 ;
    reg [3:0] addrOut;
    reg RD;
    wire [63:0] dataOut;

   
    mainMemory DUT (
        .clk1(clk1), .addrIn1(addrIn1), .dataIn1(dataIn1), .WR1(WR1),
        .clk2(clk2), .addrIn2(addrIn2), .dataIn2(dataIn2), .WR2(WR2),
        .clk3(clk3), .addrOut(addrOut), .dataOut(dataOut), .RD(RD)
    );

    
    always #2 clk2 = ~clk2;  
    always #4 clk1 = ~clk1;
    always #10 clk3 = ~clk3;

    initial begin
        
        #4;
	
	@(posedge clk1);
        addrIn1 = 3'b101;
        dataIn1 = 64'h00000000000000FF;

        WR1 = 1;
       
	repeat (2) @(posedge clk1);
        WR1 = 0;

        @(posedge clk2);	
        addrIn2 = 3'b101;
        dataIn2 = 64'h00000000000000AA;

        WR2 = 1;
	repeat (2) @(posedge clk2);
       
        WR2 = 0;
        

      @(posedge clk3);
        addrOut = 4'b0101; 
        RD = 1;

	#60;

        @(posedge clk3);
        RD = 0;
        #4 ;

        @(posedge clk3);
        addrOut = 4'b1101;
        RD = 1;

	#60
        @(posedge clk3);
        RD = 0;
         
        #60;
        $finish;
    end

    initial begin
	//	 $monitor ("\n [monitor write mem]  [%0t] WR1=0x%0d addrIn1=0x%0h  dataIn1=0x%0h ", $time, WR1, addrIn1, dataIn1);

	//	 $monitor ("\n [monitor write mem]  [%0t] WR2=0x%0d addrIn2=0x%0h  dataIn2=0x%0h ", $time, WR2, addrIn2, dataIn2);


		 $monitor ("\n [monitor read mem]  [%0t] RD=0x%0d addrOut=0x%0h dataOut=0x%0h ", $time, RD, addrOut, dataOut);
	 end

endmodule

