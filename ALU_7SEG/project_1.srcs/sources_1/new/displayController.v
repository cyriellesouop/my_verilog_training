`timescale 1ns/1ps

module displayController 
#(
     parameter DATA_WIDTH = 3,
     parameter OPCODE_WIDTH = 2,
     parameter RESULT_WIDTH = 7
)

(
     input clk,
     input rstn,
     input [OPCODE_WIDTH-1:0] opcode,
     input [DATA_WIDTH-1:0] opa,
     input [DATA_WIDTH-1:0] opb,     
     output reg  [3:0]  anode_disp0,      
     output reg [6:0]  cathode_disp0  
      
);

     wire  [RESULT_WIDTH-1:0] opcode7seg;
     wire  [RESULT_WIDTH-1:0] opa7seg;
     wire  [RESULT_WIDTH-1:0] opb7seg;
     wire  [RESULT_WIDTH-1:0] aluRes7seg;
     
     wire [6:0] cathode ;
     
     reg [1:0] anode_sel;
     reg  clk_tmp;
     reg [31:0] counter;
     
     assign cathode =  cathode_disp0;

 top #(
	    .DATA_WIDTH(DATA_WIDTH),
	    .OPCODE_WIDTH(OPCODE_WIDTH),
	    .RESULT_WIDTH(RESULT_WIDTH)
    	)
   	top_inst (
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
	 
	 ila_0 (
            clk,  
            opa,
            opb,
            opcode,
            cathode,
            rstn
            );
	 
	 
	 
	always @(posedge clk)
    begin
        if(~rstn)
            begin
                clk_tmp = 0;
               counter <= 1;
             end
        else
          begin
          
             counter <= counter + 1;
             
             if (counter == 50000000)
                begin
                   clk_tmp <= ~ clk_tmp;
                  counter <= 1;
               end             
          end 
    end
	 
	 always @(posedge clk_tmp) begin   
	   if (rstn)
	   anode_sel <= 0;
	   else
	   anode_sel <= anode_sel + 1;
	 end
	 
	 always @(*) begin
	   case (anode_sel)
            2'd0: begin
                    anode_disp0 <= 4'b1110;
                    cathode_disp0 <= opcode7seg;
                    
                   end
            2'd1: begin 
                    anode_disp0 <= 4'b1101; 
                    cathode_disp0 <= opa7seg;
                  end
            2'd2: begin
                    anode_disp0 <= 4'b1011; 
                    cathode_disp0 <= opb7seg;
                    
                   end
            2'd3 : begin
                    anode_disp0 <= 4'b0111;
                    cathode_disp0 <= aluRes7seg;
                    end
                    
            default: begin
                     anode_disp0 <= 4'b0111;
                     cathode_disp0 <= aluRes7seg;
                     end
        endcase
	 
	 end
	 

endmodule
