`timescale 1ns/1ps


module fsm

#(
    parameter ADDRESS_WIDTH = 4,
    parameter DATA_WIDTH = 12
)

(
   input clk,
   input rstn,

   //
   input [ADDRESS_WIDTH-1:0] memIn_wraddr,
   input memIn_WR,
   input [(DATA_WIDTH-1):0]  memIn_data,

   output reg [ADDRESS_WIDTH-1:0] memOut_wraddr,
   output reg  memOut_WR,
   output reg [(DATA_WIDTH-1):0]  memOut_data,

   output reg ready
);

//using Gray's code to minimize dynamic power consumption
   localparam IDLE = 3'b000;
   localparam ADDR = 3'b001;
   localparam DATA = 3'b011;
   localparam WRITE = 3'b010;
   localparam WAIT = 3'b110;

   reg [2:0] state;

   reg [ADDRESS_WIDTH-1:0] addr_reg;
   reg [DATA_WIDTH-1:0] data_reg; 

   always@(posedge clk) begin
       if(~rstn) begin
	  state <= IDLE; 
       end else begin
          case(state)
	      IDLE:
		      if(memIn_WR)
			  state <= ADDR;

	      ADDR:
		      state <= DATA;

	      DATA:  
		      state <= WRITE;

	      WRITE:
		      state <= WAIT;

	      WAIT: 
		      state <= IDLE;

          endcase
     end
  end

  always@(*) begin
    case(state)
	    IDLE : begin
		    ready <= 1'b1;
		    memOut_WR <= 1'b0;

	   	  end

	    ADDR : begin
		    ready <= 1'b0;
		    addr_reg <= memIn_wraddr;
	   	   end

           DATA: begin
		   data_reg <= memIn_data;
	  	 end 
	
	   WRITE : begin
		    memOut_wraddr <= addr_reg;
		    memOut_WR <= 1'b1;
		    memOut_data <= data_reg;

	  	 end
	    WAIT :  begin
			memOut_WR <= 1'b0;
	   	   end

     endcase
   end

endmodule
