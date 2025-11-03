`timescale 1ns/1ps
 module multiplier
#(
    parameter ADDRESS_WIDTH = 8,
    parameter DATA_WIDTH = 32 
)

(
    input  clk,
    input rstn,
    input  done_reading,
    input  [DATA_WIDTH-1:0] inputVector1,
    input  [DATA_WIDTH-1:0] inputVector2,
    output reg [2*DATA_WIDTH : 0] result_dotProduct,
    output reg startProcessing_wr
);
    localparam VALUE_WIDTH = 8;
    localparam VECTOR_LENGTH = DATA_WIDTH / VALUE_WIDTH;   
    localparam PRODUCT_WIDTH = 2*VALUE_WIDTH;

    
    reg [VALUE_WIDTH-1:0] vec1 [0:VECTOR_LENGTH-1];
    reg [VALUE_WIDTH-1:0] vec2 [0:VECTOR_LENGTH-1];
    reg [PRODUCT_WIDTH-1:0] products [0:VECTOR_LENGTH-1];
    reg [VECTOR_LENGTH-1: 0] i;
    // Stage 1: Multiplication
    
    reg [VALUE_WIDTH-1:0] vec1_reg [0:VECTOR_LENGTH-1];
    reg [VALUE_WIDTH-1:0] vec2_reg [0:VECTOR_LENGTH-1];
    (* use_dsp = "yes" *)reg [PRODUCT_WIDTH-1:0] products_reg [0:VECTOR_LENGTH-1];
    
    
    reg done_reading_sum;

    // Stage 2: sum
    reg [2*DATA_WIDTH:0] sum_reg;
    reg [2*DATA_WIDTH:0] partial_sum [0:VECTOR_LENGTH-1];

    reg done_reading_product;
    reg done_reading_final;


    // Split input vectors into vector_length cells [7:0], [15:8], [23:16], ...
    // and calculate the product of each elementary value
    genvar j;
 /*   generate
 
        for (j = 0; j < VECTOR_LENGTH; j = j+1) begin 
            assign vec1[j] = inputVector1[(j+1)*VALUE_WIDTH-1 : j*VALUE_WIDTH];
            assign vec2[j] = inputVector2[(j+1)*VALUE_WIDTH-1 : j*VALUE_WIDTH];
            assign products[j] = vec1[j] * vec2[j];
        end
    endgenerate

*/
    generate
    for (j = 0; j < VECTOR_LENGTH; j = j + 1) begin 
        
        always @(posedge clk) begin
            if (!rstn) begin
                vec1[j] <= 0;
                vec2[j] <= 0;
                products[j] <= 0;
            end else begin
                vec1[j] <= inputVector1[(j+1)*VALUE_WIDTH-1 : j*VALUE_WIDTH];
                vec2[j] <= inputVector2[(j+1)*VALUE_WIDTH-1 : j*VALUE_WIDTH];
                products[j] = vec1[j] * vec2[j];
            end
        end

//	assign  products[j] = vec1[j] * vec2[j];
    end
   endgenerate
  


    always @(posedge clk) begin
        if (!rstn) begin
            for (i = 0; i < VECTOR_LENGTH; i = i+1) begin
                vec1_reg[i] <= 0;
                vec2_reg[i] <= 0;
                products_reg[i] <= 0;
		partial_sum[i] <= 0;
            end
	   // idx <= 0;
           // accumulate_en <= 0;
            sum_reg <= 0;
            result_dotProduct <= 0;
            startProcessing_wr <= 1'b0;
	    done_reading_product<= 0;
            done_reading_sum <= 0;

            
        end else begin
            // Stage 1: Register inputs and compute products
	     done_reading_product <= done_reading;
	     if (done_reading) begin

                for (i = 0; i < VECTOR_LENGTH; i = i+1) begin
                    vec1_reg[i] <= vec1[i];
                    vec2_reg[i] <= vec2[i];
                    products_reg[i] <= products[i];
                end
	     end

	   // Stage 2: sum of  products
	   done_reading_sum <= done_reading_product;
	   if (done_reading_product) begin
	        partial_sum[0] = products_reg[0];
                for (i = 1; i < VECTOR_LENGTH; i = i+1) begin
		   partial_sum[i] = partial_sum[i-1] + products_reg[i];
                end
	    end

	   /* else if (done_reading_product &&   accumulate_en) begin
                  sum_reg <= sum_reg + products_reg[idx];
                  idx <= idx + 1;
                  if (idx >= IDX_WIDTH) begin
                     accumulate_en <= 0;
                     done_reading_sum <= 1;
                  end
             end
           */

	    // Stage 3: Final sum
            done_reading_final <= done_reading_sum;
            if (done_reading_sum) begin
                sum_reg <= partial_sum[VECTOR_LENGTH-1];
            end

	     if (done_reading_final) begin
  
                result_dotProduct <= sum_reg;
		startProcessing_wr <= 1'b1;
	     end
           
        end
    end

endmodule

