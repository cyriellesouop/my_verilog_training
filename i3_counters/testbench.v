`timescale 1ns/1ps

module testbench;

reg clk;
reg rstn;
reg [3:0] count1;
reg [3:0] count2;
reg [3:0] count3;

always #2 clk = ~clk;

initial begin
	clk=0;
	rstn=0;
	#10 rstn=1;
	#50 $finish;
end

always @(posedge clk) begin

	if (rstn==0) begin

		count1 = 0;
		count2 = 0;
		count3 = 0;
	end
	else begin
		count1 = count1 + 1;
		count2 = count2 + 2;
		count3 = count3 + 3;
	end
end

initial begin
	$monitor($time," count1 = %0d , count2 = %0d , count3 = %0d ", count1 , count2, count3);
end


endmodule
