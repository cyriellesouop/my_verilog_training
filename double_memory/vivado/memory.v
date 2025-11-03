`timescale 1ns/1ps

module Memory

	#(
	parameter DATA_WIDTH = 64,
	parameter ADDR_WIDTH = 3
	)
	(
        input clk,

	//write interface
        input [ADDR_WIDTH-1:0] addrIn,
        input [DATA_WIDTH-1:0]  dataIn,
	input WR

	//Read interface
      // input [ADDR_WIDTH-1 : 0] addrOut,
      // output reg [DATA_WIDTH-1:0] dataOut ,
      // input RD
	);


        reg [DATA_WIDTH-1:0] word [0:(2**ADDR_WIDTH)-1];
        always @(posedge clk) begin

                if (WR)
                        word[addrIn] <= dataIn;
            //    if(RD)
            //            dataOut <= word[addrOut];
             
        end


endmodule

