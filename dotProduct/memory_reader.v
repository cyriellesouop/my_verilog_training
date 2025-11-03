`timescale 1ns/1ps

module memoryReader
   #(parameter ADDRESS_WIDTH = 8,
     parameter DATA_WIDTH = 32 
    )
    (
     
     input clk,
     input rstn,
     input startProcessing,
     input [DATA_WIDTH -1:0] dataOut ,
    
     output reg done_reading,
     output reg [ADDRESS_WIDTH-1:0] rdaddr,
     output reg [DATA_WIDTH-1:0] inputVector
    );

    always @(posedge clk) begin

	if (!rstn) begin
	   inputVector <= {DATA_WIDTH{1'b0}}; 
	   rdaddr <= {DATA_WIDTH{1'b0}};
	   done_reading <= 1'b0;
	end
	else begin	
	   if(startProcessing)
	      begin 
	        //rdaddr <= rdaddr+1;
		inputVector <= dataOut; 
		rdaddr <= rdaddr+1;
		done_reading <= 1'b1;
		
	      end	
	      else
		      done_reading <= 1'b0;
	     //else
	      //begin 
	        //rdaddr <= rdaddr;
	      	//inputVector <= ; 
		
	      //end
	     
	   
        end
    end
endmodule

