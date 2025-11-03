`timescale 1ns/1ps

module mux (
	input a ,
	input b,
	input c,
	output wire z

);

	assign z = (~c && a) || (c && b); 

endmodule
