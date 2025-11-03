`timescale 1ns/1ps

module ripple_carry_adder
#( parameter DATA_WIDTH = 3)
(
	input [DATA_WIDTH-1:0] a,
	input [DATA_WIDTH-1:0] b,
	output cout,
	output [DATA_WIDTH-1:0] sum
	
);

	wire [DATA_WIDTH-1:0] carry;

	assign cout = carry [DATA_WIDTH-1];

	genvar i;
	generate

		for(i= 0; i < DATA_WIDTH; i = i+1)
		begin
			if(i == 0) // the firdt adder is a half adder
			begin
			       half_adder HA(
			       	.a(a[i]),
				.b(b[i]),
				.sum(sum[i]),
				.carry(carry[i])
			       );	
			end 
			else
			begin

			(* DONT_TOUCH = "true" *)	full_adder FA(
					.a(a[i]),
					.b(b[i]),
					.carry_in(carry[i-1]),
					.sum(sum[i]),
					.carry_out(carry[i])
				);


			end 


		end
	endgenerate

endmodule
