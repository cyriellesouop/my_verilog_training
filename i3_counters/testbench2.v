`timescale 1ns/1ps

module testbench2;

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

initial begin
	count1 <= 5;
	$display($time," count1 = %0d , count2 = %0d , count3 = %0d ", count1 , count2, count3);
        
	count2 <= 7;
        $display($time," count1 = %0d , count2 = %0d , count3 = %0d ", count1 , count2, count3);

	count3 <= 11;
        $display($time," count1 = %0d , count2 = %0d , count3 = %0d ", count1 , count2, count3);
end


initial begin
	// $monitor($time," count1 = %0d , count2 = %0d , count3 = %0d ", count1 , count2, count3);
end


endmodule
