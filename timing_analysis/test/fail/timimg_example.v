module timing_example (
	input clk,
	input rst,

	input [15:0] a,b,c,d,
	output reg [31:0] y
);

//input registers
reg [15:0] a_r, b_r,c_r,d_r;

//output register
reg [31:0] y_r;
//
always @(posedge clk) begin
	if(rst) begin
		a_r <= 0;
		b_r <= 0;
		c_r <= 0;
		d_r <= 0;
	end else begin
		a_r <= a;
		b_r <= b;
		c_r <= c;
		d_r <= d;

	end
end

always @(posedge  clk) begin
	if(rst)
		y_r <= 0;
	else 
		y_r <= ( (a_r + b_r)  * (c_r +d_r) )+ (a_r*d_r) ;

end

always @(posedge clk) begin
	if(rst)
		y <= 0;
	else
		y <= y_r;
end

endmodule
