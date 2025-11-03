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

//stage 1 : partial results
reg [16:0] sum1, sum2;
reg [31:0] mult2;
always@(posedge clk) begin
	if(rst) begin
		sum1 <= 0;
		sum2 <= 0;
		mult2 <= 0;
	end else begin
		sum1 <= a_r + b_r;
		sum2 <= c_r + d_r;
		mult2 <= a_r *d_r;
	end

end

//stage2 : main multiply
reg [31:0] mult1;
always @(posedge clk) begin
	if(rst)
		mult1 <= 0;
	else
		mult1 <= sum1 * sum2;
end
// stage 3 : combine into y_r
always @(posedge clk) begin
	if(rst)
		y_r <= 0;
	else
		y_r <= mult1 + mult2;

end	

//stage 4 : final registered output y
always @(posedge clk) begin
	if(rst)
		y <=0;
	else
		y <= y_r;
end

endmodule
