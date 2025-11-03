 `timescale 1ns/1ps
  module memoryWriter
     #( 
       parameter ADDRESS_WIDTH = 8,
       parameter DATA_WIDTH = 32      
     )

     (
      input startProcessing_wr,
      input clk,
      input rstn,
      
     input [2*DATA_WIDTH:0] result_dotProduct,
     output reg [2*DATA_WIDTH:0] input_outputMemory,
     output reg [ADDRESS_WIDTH-1:0] wraddr,
     output reg done_writing
     );
 
     
     always @(posedge clk) begin
 
         if (!rstn) begin
	    input_outputMemory <= 0;
	    wraddr <= 0;
	    done_writing <= 0;
          end
         else begin      
		 if( startProcessing_wr) begin
              		input_outputMemory <= result_dotProduct;
			done_writing <= 1'b1;
			wraddr <= wraddr+1;
	    	end
		else begin
	      		input_outputMemory <= 0;
			done_writing <= 1'b0;
			
		end
            end
     end
 endmodule

