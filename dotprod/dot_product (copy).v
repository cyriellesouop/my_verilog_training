`timescale 1ns/1ps
module dotProduct 
	#(
	parameter VECTOR_LENGTH = 3,	
	parameter VECTOR_LENGTH_SM = 3,
	parameter VALUE_WIDTH = 8)
	(
	input clk,
	input rstn,
	input done_reading,
	input [((VALUE_WIDTH*VECTOR_LENGTH)-1):0] inputVector1,
        input [((VALUE_WIDTH*VECTOR_LENGTH)-1):0] inputVector2,
	output reg startProcessing_wr, 
	output reg [$clog2(VECTOR_LENGTH * ((1 << VALUE_WIDTH) - 1) * ((1 << VALUE_WIDTH) - 1) + 1)-1 : 0] result_dotProduct
	);
	//localparam RESULT_WIDTH = $clog2(VECTOR_LENGTH * ((1 << VALUE_WIDTH) - 1) * ((1 << VALUE_WIDTH) - 1) + 1);

	localparam RESULT_WIDTH = $clog2(VECTOR_LENGTH * ((1 << VALUE_WIDTH) - 1) * ((1 << VALUE_WIDTH) - 1) + 1);
	localparam RESULT_WIDTH_SM = $clog2(VECTOR_LENGTH_SM * ((1 << VALUE_WIDTH) - 1) * ((1 << VALUE_WIDTH) - 1) + 1) ;
	localparam NUM_MULT = VECTOR_LENGTH / VECTOR_LENGTH_SM ;
	localparam DATA_WIDTH_SM = VALUE_WIDTH*VECTOR_LENGTH_SM;

	reg [NUM_MULT-1:0] done_reading_MULTS ;
	wire [DATA_WIDTH_SM-1:0] inputVector1_MULTS [NUM_MULT-1:0];
	wire [DATA_WIDTH_SM-1:0] inputVector2_MULTS [NUM_MULT-1:0];
	wire [RESULT_WIDTH_SM-1:0]  result_dotProduct_MULTS [NUM_MULT-1:0]; 

	reg [NUM_MULT-1:0] k;
	
	reg [RESULT_WIDTH-1:0] sum_result;



// block to slice inputs of different submodules
	genvar j;
	generate
          for (j = 0; j < NUM_MULT; j = j+1) begin 
            assign inputVector1_MULTS[j] = inputVector1[(j+1)*DATA_WIDTH_SM-1 : j*DATA_WIDTH_SM];
            assign inputVector2_MULTS[j] = inputVector2[(j+1)*DATA_WIDTH_SM-1 : j*DATA_WIDTH_SM];
           end
        endgenerate

// block to distribute done_reading to all submodules

	always @(posedge clk) begin
		if(done_reading) 
			done_reading_MULTS <= {NUM_MULT{1'b1}};

		else 
			done_reading_MULTS <= {NUM_MULT{1'b0}};
	end

// Instantiation of submodules
	genvar i;
	generate

		for(i= 0; i < NUM_MULT; i = i+1)
		begin
			multiplier #(
			.VECTOR_LENGTH(VECTOR_LENGTH_SM),
			.VALUE_WIDTH(VALUE_WIDTH) )
			MULT  (
				.clk(clk),
				.rstn(rstn),
				.done_reading(done_reading_MULTS[i]),
				.inputVector1( inputVector1_MULTS[i]),
				.inputVector2( inputVector2_MULTS[i]),
				.result_dotProduct(result_dotProduct_MULTS[i])
			);	
		end
	endgenerate

// sum of all the resutls of submodules 

	always @(posedge clk) begin

		if (!rstn) 
		begin
            		result_dotProduct <= {RESULT_WIDTH{1'b0}};
			startProcessing_wr <= 1'b0;
        	end

		else
		begin

			sum_result = {RESULT_WIDTH{1'b0}};

			for(k= 0; k < NUM_MULT; k = k+1)
       				sum_result = sum_result + result_dotProduct_MULTS[k];	
			result_dotProduct <= sum_result;
			startProcessing_wr <=1'b1;
		
		end
	end
endmodule
