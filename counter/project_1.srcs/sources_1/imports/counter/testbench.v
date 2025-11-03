`timescale 1ns/1ps

module testbench;

localparam PERIOD = 4;
parameter DATA_WIDTH = 4;
reg clk = 0;
reg rstn ;
reg direction ;
wire [DATA_WIDTH-1:0] count;


counter #(.DATA_WIDTH(DATA_WIDTH))

	DUT (
	.clk(clk),
	.rstn(rstn),
	.direction (direction),
	.count (count)
	);


always #(PERIOD/2) clk = ~clk;


initial begin
	rstn =0;
	direction = 0;
	#50;
       	rstn = 1;

	#300;
       	direction = 1;
	#300;
       	direction = 0;
	#300;

end

initial begin

	$monitor( " Time = %0t: rstn = %b , direction = %b, count = %d", $time,  rstn, direction, count);
	#1000;

	$finish;

end

endmodule
