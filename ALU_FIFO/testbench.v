`timescale 1ns/1ps

module testbench;
 
    parameter DATA_WIDTH = 4;
    parameter OPCODE_WIDTH = 2;
    parameter STATE_WIDTH = 3;
    parameter DEPTH = 4;
    parameter FIFO_WIDTH = (2 * DATA_WIDTH) + OPCODE_WIDTH;

    //clock period
    parameter PERIOD = 4; 
    
    reg clk=0;
    reg rstn;
    reg wr;
    reg rd;
    reg [FIFO_WIDTH-1:0] packetIn, packetInTemp;
    wire full;
    wire empty;
    wire [DATA_WIDTH:0] dataOut;
    
    reg [DATA_WIDTH:0] dataOutTemp;

    // arrays indices
    reg [FIFO_WIDTH-1:0]  resultOut_indice;

    // validate results
    reg final_result;
    
    //results arrays
    reg [DATA_WIDTH:0] resultIn [0:2**FIFO_WIDTH-1];
    reg [DATA_WIDTH:0] resultOut [0: 2**FIFO_WIDTH-1] ;
    
    // function to calculate the expected output of the fifo in
    function [DATA_WIDTH : 0] calculation(
    	input [FIFO_WIDTH-1:0] packetIn 
	);
    	reg [DATA_WIDTH-1:0] opA;
    	reg [DATA_WIDTH-1:0] opB;
    	reg [OPCODE_WIDTH-1 : 0] opCode;
    	reg [DATA_WIDTH : 0] result;
    
   	 begin
        	opCode = packetIn[OPCODE_WIDTH-1:0];
        	opB = packetIn[OPCODE_WIDTH + DATA_WIDTH - 1 : OPCODE_WIDTH];
        	opA = packetIn[(2*DATA_WIDTH) + OPCODE_WIDTH-1 :  DATA_WIDTH + OPCODE_WIDTH];
        
       		if (opCode == 2'b00)
            		result = opA + opB;
        	else if (opCode == 2'b01)
            		result = opA - opB;
        	else if (opCode == 2'b10)
            		result = opA >> opB;
        	else if (opCode == 2'b11)
            		result = opA << opB;
        	calculation = result;
    	end
	endfunction


	function  integer  verification(input clk );
    		reg [FIFO_WIDTH-1:0] i;
		integer mismatch;
		 
    		begin
			mismatch = 0;
        		for (i = 0; i < 2**FIFO_WIDTH-1; i = i + 1) begin
            			if (resultIn[i] !== resultOut[i]) begin
					mismatch = mismatch + 1; 
               				$display("Mismatch at index %0d: resultIn = %0d, resultOut = %0d ", i, resultIn[i], resultOut[i]);
           			 end
        		end
			verification = mismatch;
    		end
	endfunction


    	ALUFIFO #(
        .DATA_WIDTH(DATA_WIDTH),
        .OPCODE_WIDTH(OPCODE_WIDTH),
        .STATE_WIDTH(STATE_WIDTH),
        .DEPTH(DEPTH)
    ) DUT (
        .clk(clk),
        .rstn(rstn),
        .packetIn(packetIn),
        .wr(wr),
        .rd(rd),
	.empty(empty),
	.full(full),
        .dataOut(dataOut)
    );

    always #2 clk = ~clk;  

	initial begin
	    packetIn = 0;
		rstn = 0;
		wr = 0;
		repeat(2)@(posedge clk);
                rstn = 1;
		repeat(2)@(posedge clk);

            for (packetIn = 0 ; packetIn < (2**FIFO_WIDTH-1) ; packetIn = packetIn+1 ) begin
			wait (full == 0);
			@(posedge clk);
			wr = 1;
			resultIn[packetIn] = calculation (packetIn);
			@(posedge clk);
		       	wr = 0;
		    @(posedge clk);
		end
	 end


// initial to end the simulation
	initial begin
		#10000000;
		$finish;
    	end

// initial to validate the data after writing in the input in the system and reading out the outputs
	initial begin
		#1000000;
            	final_result = verification(clk);
	    	$monitor("number of mismatch is %0d", final_result);

	   	 if (final_result == 0)
			 $monitor(" Successfully done !!!");
	end

// initial to read the data
	initial begin
		resultOut_indice = 0;
		rd = 0;

		while (resultOut_indice< (2**FIFO_WIDTH)-1  ) begin 	
			wait(empty == 0);
			@(posedge clk);
			rd = 1;
			@(posedge clk);
			dataOutTemp = dataOut;
			if (dataOutTemp !== 5'bxxxxx ) begin
                        	resultOut[resultOut_indice] = dataOutTemp;
                          	resultOut_indice = resultOut_indice + 1;
			end

			 @(posedge clk);
			 rd = 0;
		 end
	end
endmodule

