`timescale 1ns/1ps

module mux4input(
	input a1,
	input b1,
	input a2,
	input b2,
	input c1,
	input c2,
	output wire z
);

	wire z1;
	wire z2;

	mux  mux1(
		.a(a1),
		.b(b1),
		.c(c1),
		.z(z1)
	);

	mux  mux2(
		.a(a2),
                .b(b2),
                .c(c1),
                .z(z2)
	);

	mux  mux3(
                .a(z1),
                .b(z2),
                .c(c2),
                .z(z)
        );

endmodule
