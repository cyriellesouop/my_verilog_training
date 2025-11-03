`timescale 1ns/1ps

module testbench;

    parameter PERIOD = 4; 
    parameter DATA_WIDTH = 3;
    parameter OPCODE_WIDTH = 2;
    parameter RESULT_WIDTH = 7;

    reg clk=0;
    reg rstn;
    reg [OPCODE_WIDTH-1:0] opcode;
    reg [DATA_WIDTH-1:0]opa;
    reg [DATA_WIDTH-1:0] opb;

    wire [RESULT_WIDTH-1:0] opcode7seg;
    wire [RESULT_WIDTH-1:0] opa7seg;
    wire [RESULT_WIDTH-1:0] opb7seg;
    wire [RESULT_WIDTH-1:0] aluRes7seg;

    reg [OPCODE_WIDTH : 0 ] i;
    integer counter;
    reg [ DATA_WIDTH-1 : 0 ] a, b;
    reg validateOpcode;
    reg validateOpa;
    reg validateOpb;
    reg validateAluRes;

    // to store the result of the alu in the main testbench
    reg [DATA_WIDTH-1:0] result;

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
                	6: segctrl = 7'b0010010;
                	7: segctrl = 7'b1111000;

                	default: segctrl = 7'b1111111;
        	endcase
	end 
    endfunction

    // function to calculate result
    function [DATA_WIDTH-1:0] aluOutput(
    input [OPCODE_WIDTH-1:0] opcode,
    input [DATA_WIDTH-1:0] opa,
    input [DATA_WIDTH-1:0] opb
	);

   	 begin
        	if (opcode == 2'b00)
            		aluOutput = opa & opb;
       		 else if (opcode == 2'b01)
           		 aluOutput = opa & opb;
        	else if (opcode == 2'b10)
            		aluOutput = opa ^ opb;
        	else if (opcode == 2'b11)
            		aluOutput = opa ^~ opb;
    	end
    endfunction

    //function to verify the result of the operation
    function reg verificationAluRes (
	input [RESULT_WIDTH-1:0] aluRes,
	input [RESULT_WIDTH-1:0] aluRes7seg

    );
    	reg [RESULT_WIDTH-1:0] aluRes7segRes;
	begin
		verificationAluRes = (aluRes == aluRes7seg);
	end
   endfunction

   // function to verify opcode
   function reg verificationOpcode( 
   	input [RESULT_WIDTH-1:0] opcode,
   	input [RESULT_WIDTH-1:0] opcode7seg   
   	);
	begin
		verificationOpcode = (opcode == opcode7seg );
	end
	endfunction

	//function to verify opa
   function reg verificationOpa(
	input [RESULT_WIDTH-1:0] opa,
	input [RESULT_WIDTH-1:0] opa7seg
	);
	reg [RESULT_WIDTH-1:0] opa7segRes;
	begin
		verificationOpa = (opa == opa7seg);
	end
   endfunction

   // function to verify opb
   function reg verificationOpb(
        input [RESULT_WIDTH-1:0] opb,
        input [RESULT_WIDTH-1:0] opb7seg
        );
        reg [RESULT_WIDTH-1:0] opb7segRes;
        begin
		verificationOpb = (opb ==opb7seg);
        end
   endfunction

    top #(
	    .DATA_WIDTH(DATA_WIDTH),
	    .OPCODE_WIDTH(OPCODE_WIDTH),
	    .RESULT_WIDTH(RESULT_WIDTH)
    	)
   	DUT (
	    .clk(clk),
            .rstn(rstn),
            .opcode(opcode),
            .opa(opa),
            .opb(opb),
	    .opcode7seg(opcode7seg),
            .opa7seg(opa7seg),
            .opb7seg(opb7seg),
            .aluRes7seg(aluRes7seg)
	 );
	
	 always #(PERIOD/2) clk = ~clk;

	initial begin 
		rstn = 0;
		counter = 0;
		repeat(3) @(posedge clk);
		rstn = 1;
		
		begin : test
			for (i = 0; i < (2**OPCODE_WIDTH); i = i + 1) begin
            			opcode = i[OPCODE_WIDTH-1:0];
           			for (a = 0; a < (2**DATA_WIDTH)-1; a = a + 1) begin
	        			opa = a;
                			for (b = 0; b < (2**DATA_WIDTH)-1; b = b + 1) begin
                    				opb = b;
						@(posedge clk);
						validateOpcode = verificationOpcode(opcode7seg , segctrl(opcode));
						validateOpa = verificationOpa(opa7seg , segctrl(opa));
						validateOpb = verificationOpb(opb7seg , segctrl(opb));
						result = aluOutput(opcode, opa, opb);
						validateAluRes = verificationAluRes(aluRes7seg, segctrl(result));
					
					// 	$display("op = %d, a = %d, b= %d , res = %d, opcode = %d, opa = %d, opb = %d, result = %d, opcode7seg = %d, opa7seg= %d, opb7seg = %d, aluRes7seg =  %d"    , opcode, opa, opb, result, segctrl(opcode),segctrl(opa),segctrl(opb), segctrl(result), opcode7seg, opa7seg, opb7seg, aluRes7seg);
		    				if (!(validateOpcode & validateOpa & validateOpb & validateAluRes))
		    				begin
							counter = counter + 1;
			    		//		$display("Error arise during the simulation!!");
			    				$display("Error ----> op = %d, a = %d, b= %d , res = %d, opcode = %d, opa = %d, opb = %d, result = %d, opcode7seg = %d, opa7seg= %d, opb7seg = %d, aluRes7seg =  %d", opcode, opa, opb, result, segctrl(opcode),segctrl(opa),segctrl(opb), segctrl(result), opcode7seg, opa7seg, opb7seg, aluRes7seg);
		    	    		//		disable test;
		    				end	    
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
