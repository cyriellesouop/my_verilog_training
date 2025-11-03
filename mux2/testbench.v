`timescale 1ns/1ps

module testbench;
	reg a1;
	reg b1;
	reg a2;
	reg b2;
	reg c1;
	reg c2;
	wire z;

	reg [5 : 0] i, k;
	reg  result_obt [0 : (2**6)-1] ;
        reg  result_exp [0 : (2**6)-1]  ;
	integer error_count;
	
//function to validate the result
	function  validation(input[5:0] input_value);
		reg result;
		reg  a1_val;
	        reg  b1_val;
       		reg  a2_val;
        	reg  b2_val;
        	reg  c1_val;
        	reg  c2_val;
		
		begin	
			{a1_val,b1_val,a2_val,b2_val,c1_val,c2_val} =  input_value;
		
			result = (a1_val && ~c1_val && ~c2_val) || (b1_val && c1_val && ~c2_val) || (a2_val && ~c1_val && c2_val) || (b2_val && c1_val && c2_val);
			
			validation = result;
		end
	endfunction

	mux4input DUT(.a1(a1),  .b1(b1), .a2(a2), .b2(b2), .c1(c1), .c2(c2), .z(z));
   
//initial to compute the current(obtained) outpout
	initial begin
		for(k = 0; k<(2**6)-1 ; k = k+1) begin
			{a1,b1,a2,b2,c1,c2} = k; 
			#2;
			result_exp[k] = validation(k); 
			result_obt[k] = z;

			$display(" k %b ------> a1 %b , b1 %b , a2 %b , b2 %b , c1 %b , c2 %b  : , z = %b | result_obt %b | result_exp %b", k, a1, b1, a2 , b2, c1, c2, z,  result_obt[k], result_exp[k]);

		end 
		#2;

		error_count = 0;
		i = 0;

                while(i < (2**6)-1) begin
                        if(result_obt[i] !== result_exp[i] ) begin
                                error_count = error_count + 1;
				$display(" i %b ------> a1 %b , b1 %b , a2 %b , b2 %b , c1 %b , c2 %b  : , result_obt %b |  result_exp  %b", i, a1, b1, a2 , b2, c1, c2, result_obt[i] , result_exp[i] );
                        end
			i = i+1;
                end

                if (error_count !== 0 )
                        $monitor("the number of error is %0d : ", error_count );
                else
  	                $monitor("Successfully done !!! ");
	
	end

	initial begin
		#80;
		for(j = 0; j < (2**4)-1 ; j = j+1) begin
                        {a1,b1,a2,b2} = j;
                        c1 = 1'bx;
                        c2 = 1'bx;
                        #5;
                        $display("a1 %b , b1 %b , a2 %b , b2 %b , c1 %b , c2 %b  : , z = %b", a1, b1, a2 , b2, c1, c2, z);
                end
		#5;
	end

/*
initial begin
                #200;
                for(j = 0; j < (2**4)-1 ; j = j+1) begin
                        {a1,b1,a2,b2} = j;
                        c1 = 1'bx;
                        c2 = 1'bz;
                        #5;
                        $display("a1 %b , b1 %b , a2 %b , b2 %b , c1 %b , c2 %b  : , z = %b", a1, b1, a2 , b2, c1, c2, z);
                end
		#5;
        end

	initial begin
                #300;
                for(j = 0; j < (2**4)-1 ; j = j+1) begin
                        {a1,b1,a2,b2} = j;
                        c1 = 1'bz;
                        c2 = 1'bx;
                        #5;
                        $display("a1 %b , b1 %b , a2 %b , b2 %b , c1 %b , c2 %b  : , z = %b", a1, b1, a2 , b2, c1, c2, z);
                end
                #5;
        end

	*/
endmodule
