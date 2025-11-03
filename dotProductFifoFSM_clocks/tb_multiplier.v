`timescale 1ns/1ps

module tb_multiplier;

    // Parameters
    localparam DATA_WIDTH = 12;
    localparam ADDRESS_WIDTH = 8;
    localparam VALUE_WIDTH = 4;
    localparam VECTOR_LENGTH= DATA_WIDTH / VALUE_WIDTH;
    localparam PERIOD = 4;

    // dot product ports
    reg clk=0;
    reg rstn;
    reg done_reading;
    reg [(VALUE_WIDTH*VECTOR_LENGTH)-1:0] inputVector1;
    reg [(VALUE_WIDTH*VECTOR_LENGTH)-1:0] inputVector2;
    wire [2*DATA_WIDTH:0] result_dotProduct;
    wire startProcessing_wr;
    reg [2*DATA_WIDTH:0] expected_result;

    reg [(2**ADDRESS_WIDTH)-1:0 ] i;
    reg [VECTOR_LENGTH-1 : 0] j;
    reg [(2**VALUE_WIDTH)-1:0]val;
   
    multiplier #(
        .ADDRESS_WIDTH(ADDRESS_WIDTH),
        .DATA_WIDTH(DATA_WIDTH)
    ) DUT (
        .clk(clk),
        .rstn(rstn),
        .done_reading(done_reading),
        .inputVector1(inputVector1),
        .inputVector2(inputVector2),
        .result_dotProduct(result_dotProduct),
	.startProcessing_wr(startProcessing_wr)
    );

    always #(PERIOD/2) clk = ~clk;



    // dot product verification function
    function integer dot_product;
        input [DATA_WIDTH-1:0] v1;
        input [DATA_WIDTH-1:0] v2;
        reg [VECTOR_LENGTH-1:0] k;
        reg [VALUE_WIDTH-1:0] e1, e2;
        begin
            dot_product = 0;
            for (k = 0; k < VECTOR_LENGTH; k = k+1) begin
            e1 = (v1 >> (k*VALUE_WIDTH)) & ((1 << VALUE_WIDTH) - 1);
            e2 = (v2 >> (k*VALUE_WIDTH)) & ((1 << VALUE_WIDTH) - 1);
            dot_product = dot_product + (e1 * e2);
        end
        end
    endfunction

  
    initial begin
        
        rstn = 0;
      	val = 0; 
      	done_reading =0;

        @(posedge clk);

        rstn = 1;
        done_reading = 1;
        
         @(posedge clk);

       	for (i = 0; i < 8; i = i + 1) begin
            
            inputVector1 = 0;
            inputVector2 = 0;
            for (j = 0; j < VECTOR_LENGTH; j = j + 1) begin
                inputVector1[(j*VALUE_WIDTH) +: VALUE_WIDTH] = val;
                inputVector2[(j*VALUE_WIDTH) +: VALUE_WIDTH] = val + 2;  

		@(posedge clk);
		expected_result = dot_product(inputVector1, inputVector2);

		repeat(4) @(posedge clk);
		$display ("\n [%0t]  vec1=%b vec2=%0b result_dotProduct=%0d, expected_result = %0d", $time,  inputVector1, inputVector1, result_dotProduct, expected_result );

                val = val + 1;
		@(posedge clk);
            end	
      end 

      #100 $finish;
    end
    
endmodule

