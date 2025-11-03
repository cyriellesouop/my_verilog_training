`timescale 1ns/1ps

module comparator(
    input a,
    input b,
    output s
);

	assign s = (a == b);

endmodule
