`timescale 1ns/1ps

module testbench ();

	reg a;
	reg b;
	reg c;
	wire z;

	reg [2:0] i;

      mux DUT (
	      .a(a), 
	      .b(b), 
	      .c(c), 
	      .z(z));

	initial begin
		for (i=0 ; i< (2**3)-1; i = i+1) begin
			{a,b,c} = i;
			#5;
			$display("a %b , b %b , c %b : , z = %b", a, b, c , z);
		end
	end

	initial begin
		#40;
		$finish;
	end

endmodule
