`timescale 1ns/1ps
module multiplier
#(
    parameter VECTOR_LENGTH = 2,
    parameter VALUE_WIDTH   = 8
)
(
    input  clk,
    input rstn,
    input  done_reading,
    input  [(VALUE_WIDTH*VECTOR_LENGTH)-1:0] inputVector1,
    input  [(VALUE_WIDTH*VECTOR_LENGTH)-1:0] inputVector2,
    output reg [$clog2(VECTOR_LENGTH * ((1 << VALUE_WIDTH) - 1) * ((1 << VALUE_WIDTH) - 1) + 1)-1:0] result_dotProduct
);

     localparam RESULT_WIDTH = $clog2(VECTOR_LENGTH * ((1 << VALUE_WIDTH) - 1) * ((1 << VALUE_WIDTH) - 1) + 1);

	// temporal result
    reg [RESULT_WIDTH-1 :0] sum;
    
   localparam PRODUCT_WIDTH = 2*VALUE_WIDTH;
   //localparam RESULT_WIDTH = $clog2(VECTOR_LENGTH * ((1 << VALUE_WIDTH) - 1) * ((1 << VALUE_WIDTH) - 1) + 1);

    wire [VALUE_WIDTH-1:0] vec1 [0:VECTOR_LENGTH-1];
    wire [VALUE_WIDTH-1:0] vec2 [0:VECTOR_LENGTH-1];
   wire [PRODUCT_WIDTH-1:0] products [0:VECTOR_LENGTH-1];

    reg [VECTOR_LENGTH-1: 0] i;

    // Split input vectors into vector_length cells [7:0], [15:8], [23:16], ...
    // and calculate the product of each elementary value
    genvar j;
    generate
 
        for (j = 0; j < VECTOR_LENGTH; j = j+1) begin 
            assign vec1[j] = inputVector1[(j+1)*VALUE_WIDTH-1 : j*VALUE_WIDTH];
            assign vec2[j] = inputVector2[(j+1)*VALUE_WIDTH-1 : j*VALUE_WIDTH];
            assign products[j] = vec1[j] * vec2[j];
        end
    endgenerate

    // Compute dot product 
    
    always @(posedge clk) 
    begin
	if(!rstn) 
	begin
		result_dotProduct <= {RESULT_WIDTH{1'b0}};
	end
	else 
	begin	
          if (done_reading) begin
            sum = 0;
             for (i = 0; i < VECTOR_LENGTH; i = i+1) 
	          sum = sum + products[i];
             result_dotProduct <= sum;
             
          end
       end
     end


endmodule

