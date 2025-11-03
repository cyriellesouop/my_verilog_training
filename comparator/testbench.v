`timescale 1ns/1ps

module testbench;

	parameter N = 4;
	reg  [N-1:0] a;
    	reg  [N-1:0] b;
    	wire z;

    	generator #(.N(N)) DUT (
        	.a(a),
        	.b(b),
        	.z(z)
    	);


       initial begin
        
        	$monitor("%0t\t %b\t %b\t %b", $time, a, b, z);
       
	end

	initial
	begin	
        	a = 4'b0000; 
		b = 4'b0000; 
		#4;
        	a = 4'b1010; 
		b = 4'b1010; 
		#4;
        	a = 4'b1111; 
		b = 4'b1101; 
		#4;
        	a = 4'b0101; 
		b = 4'b0111; 
		#4;
        	a = 4'b1111; 
		b = 4'b1111; 
		#4;
		a = 'bx;
		b = 'bx;
		#4;
		a = 'bx;
		b = 'bz;
		#4;	#4;	#4;	#4;	

    	end

endmodule


