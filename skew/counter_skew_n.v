`timescale 1ns/1ps

//Library UNISIM;
//use UNISIM.vcomponents.all;

module counter_skew_n(
	input clk,
	input d,
	input c,
	output reg q1,
	output reg q2,
	output reg q3
    );

    // Goal : for delay through a LUT (instead of global clock routing)
    wire clk_delayed;
    //assign clk_delayed = clk & c; // LUT will be inserted

    always @(posedge clk) q1 <= d; // flip-flop driven by direct clock

    // Flip-flops driven by "fabric-routed clock"
    // //potential risk of skew: depending of placement,
    // there's no guarantee that the "clk_delayed" signal will reach flip flop
    // q2 and q3 at the same time
    always @(posedge clk_delayed) q2 <= d;
    always @(posedge clk_delayed) q3 <= q2 ^ c;

    BUFGCE BUFGCE_inst (
	.O(clk_delayed), // 1-bit output: clock output
	.CE(c),  // 1-bit input: clock enable input for IO
	.I(clk) // 1-bit input : Primary clock
     );

endmodule

	
