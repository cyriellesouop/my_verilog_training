`timescale 1ns/1ps

module top

#(
     parameter DATA_WIDTH = 3,
     parameter RESULT_WIDTH = 7
)

(
     input [DATA_WIDTH-1:0] opa,
     input [DATA_WIDTH-1:0] opb,
     output  cout,
     output  [RESULT_WIDTH-1:0] opa7seg,
     output  [RESULT_WIDTH-1:0] opb7seg,
     output  [RESULT_WIDTH-1:0] sum7seg

);

	wire [DATA_WIDTH-1:0] sum;

	(* DONT_TOUCH = "true" *) ripple_carry_adder #(.DATA_WIDTH(DATA_WIDTH))

	   ratop(
		.a(opa),
		.b(opb),
		.sum(sum),
		.cout(cout)
	   );

	segConv #(.DATA_WIDTH(DATA_WIDTH),.RESULT_WIDTH(RESULT_WIDTH))
	
	   segContop(
                .opa(opa),
                .opb(opb),
                .sum(sum),
		.opa7seg(opa7seg),
		.opb7seg(opb7seg),
		.sum7seg(sum7seg)		
	   );

endmodule

