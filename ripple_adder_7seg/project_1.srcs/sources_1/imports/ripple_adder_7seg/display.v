`timescale 1ns/1ps

module display
#(
     parameter DATA_WIDTH = 3,
     parameter RESULT_WIDTH = 7
)

(
     input clk,
     input rstn,
     input [DATA_WIDTH-1:0] opa,
     input [DATA_WIDTH-1:0] opb,     
     output  cout,
     output reg  [3:0]  anode_disp0,      
     output reg [6:0]  cathode_disp0       
);
    
     wire  [RESULT_WIDTH-1:0] opa7seg;
     wire  [RESULT_WIDTH-1:0] opb7seg;
     wire  [RESULT_WIDTH-1:0] sum7seg;
    
     wire [6:0] cathode ;    
     reg [1:0] anode_sel;
     reg [15:0] refresh_counter;

     assign cathode =  cathode_disp0;

 top #(
	    .DATA_WIDTH(DATA_WIDTH),
	    .RESULT_WIDTH(RESULT_WIDTH)
    	)
   	top_inst (
            .opa(opa),
            .opb(opb),
	    .cout (cout),
            .opa7seg(opa7seg),
            .opb7seg(opb7seg),
            .sum7seg(sum7seg)
	 );
 
	 always @(posedge clk or negedge rstn) begin   
	   if (!rstn) begin
	   anode_sel <= 0;
	   refresh_counter <= 0;
	   
	   end
	   else begin
        refresh_counter <= refresh_counter + 1;
        if (refresh_counter == 0) 
	       anode_sel <= anode_sel + 1;
	    end
	 end
	 
	 always @(*) begin
	   case (anode_sel)
            2'd0: begin
                    anode_disp0 <= 4'b1110;
                    cathode_disp0 <= opa7seg;
                    
                   end
      
            2'd1: begin
                    anode_disp0 <= 4'b1101; 
                    cathode_disp0 <= opb7seg;
                    
                   end
            2'd2 : begin
                    anode_disp0 <= 4'b1011;
                    cathode_disp0 <= sum7seg;
                    end
                    
            default: begin
                     anode_disp0 <= 4'b1011;
                     cathode_disp0 <= sum7seg;
                     end
        endcase
	 
	 end
	 

endmodule

