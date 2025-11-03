`timescale 1ns/1ps

module tb_segctrl;

   parameter PERIOD = 4;
    parameter DATA_WIDTH =3;
    parameter RESULT_WIDTH = 7;

    reg clk=0;
    reg [DATA_WIDTH-1 : 0] dataIn;
    wire  [RESULT_WIDTH-1 : 0 ] dataOut;


    top #( 
   	.DATA_WIDTH(DATA_WIDTH),
	.RESULT_WIDTH(RESULT_WIDTH)
        )
	DUT (
	    .dataIn(dataIn),
	    .dataOut(dataOut)
    );

    always #(PERIOD/2) clk = ~clk;

    initial begin
	    for 


    end


endmodule

