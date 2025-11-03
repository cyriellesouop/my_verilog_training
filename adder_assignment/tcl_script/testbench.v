`timescale 1ns/1ps

module testbench;

    parameter PERIOD = 4; 
    parameter DATA_WIDTH = 3;
    parameter RESULT_WIDTH = 7;

    reg [DATA_WIDTH-1:0]opa;
    reg [DATA_WIDTH-1:0] opb;
    wire cout;

    wire [RESULT_WIDTH-1:0] opa7seg;
    wire [RESULT_WIDTH-1:0] opb7seg;
    wire [RESULT_WIDTH-1:0] sum7seg;

    integer counter;
    reg [ DATA_WIDTH-1 : 0 ] a, b;
    reg validate;

    function [RESULT_WIDTH-1:0] segctrl(
    	input [DATA_WIDTH-1 : 0] dataIn
    );
   	 begin
		case(dataIn)
                	0: segctrl = 7'b1000000;
                	1: segctrl = 7'b1111001;
                	2: segctrl = 7'b0100100 ;
               		3: segctrl = 7'b0110000;
                	4: segctrl = 7'b0011001;
                	5: segctrl = 7'b0010010;
                	6: segctrl = 7'b0000010;
                	7: segctrl = 7'b1111000;

                	default: segctrl = 7'b1111111;
        	endcase
	end 
    endfunction

    //function to verify opa, opb and  result of the operation
    function reg verification (
	input [DATA_WIDTH-1:0] opa,
	input [DATA_WIDTH-1:0] opb,
	input cout,

	input [RESULT_WIDTH-1:0] opa7seg,
	input [RESULT_WIDTH-1:0] opb7seg,
	input [RESULT_WIDTH-1:0] sum7seg

    );
    	reg [DATA_WIDTH:0] i;
	reg [DATA_WIDTH-1:0] sumOutput;
	reg cinOutput;
	begin
		cinOutput = 0;
        	for (i = 0; i < DATA_WIDTH; i = i + 1) begin
            		sumOutput[i] = opa[i] ^ opb[i] ^ cinOutput;
            		cinOutput = (opa[i] & opb[i]) | (opa[i] & cinOutput) | (opb[i] & cinOutput);
        	end
		verification = (segctrl(opa) == opa7seg) && 
			       (segctrl(opb) == opb7seg) && 
			       (segctrl(sumOutput) == sum7seg ) && 
			       (cinOutput == cout);
	end
   endfunction

   
    top #(
	    .DATA_WIDTH(DATA_WIDTH),
	    .RESULT_WIDTH(RESULT_WIDTH)
    	)
   	DUT (
            .opa(opa),
            .opb(opb),
	    .cout(cout),
            .opa7seg(opa7seg),
            .opb7seg(opb7seg),
            .sum7seg(sum7seg)
	 );
	

	initial begin 
		counter = 0;
		
		begin : test
			
           		for (a = 0; a < (2**DATA_WIDTH)-1; a = a + 1) begin
	        		opa = a;
                		for (b = 0; b < (2**DATA_WIDTH)-1; b = b + 1) begin
                    			opb = b;

					#4;
					validate = verification(opa, opb,  cout, opa7seg, opb7seg, sum7seg);
					$display("opa = %d, opb = %d, cout = %b, opa7seg= %d, opb7seg = %d, sum7seg = %d", opa, opb,  cout,  opa7seg, opb7seg, sum7seg);	
					if (!(validate))
		    			begin
						counter = counter + 1;
			    		//      $display("Error arise during the simulation!!");
			    			$display("Error ---->  opa = %d, opb = %d,  cout = %b, opa7seg= %d, opb7seg = %d, sum7seg = %d", opa, opb, cout,  opa7seg, opb7seg, sum7seg);
		    	    		//	disable test;
		    			end	    
				end
			end
			if (counter === 0)
		  		$display ("All tests has passed");
			else
				$display(  " counter = %d Error arise during the simulation!! ", counter );

		end
		
		$finish;
	end
endmodule
