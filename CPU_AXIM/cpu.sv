`timescale 1ns/1ps


module cpu 
#(
   parameter ADDRESS_WIDTH = 32,
   parameter DATA_WIDTH = 8
)
(
   input clk,
   input rstn,

   //write address channel
   input [ADDRESS_WIDTH-1:0] awaddr,
   input awvalid,
   output reg awready,

   //write data channel
   input [DATA_WIDTH-1:0] wdata,
   input wvalid,
   output reg wready,

   //write response channel
   output reg [1:0] bresp,
   output reg bvalid,
   input bready,

   //read address channel
   input [ADDRESS_WIDTH-1:0] araddr,
   input arvalid,
   output reg arready,

   //read data channel
   output reg [DATA_WIDTH-1:0] rdata,
   output reg rvalid,
   output reg [1:0] rresp,
   input rready
);

reg [ADDRESS_WIDTH-1:0] waddr;
reg [ADDRESS_WIDTH-1:0] raddr;
reg [DATA_WIDTH-1:0] tmp_data;

reg [DATA_WIDTH-1:0] op1;
reg [DATA_WIDTH-1:0] op2;
reg [DATA_WIDTH-1:0] opCode;
reg [DATA_WIDTH-1:0] result;

typedef enum {IDLE,  WR_DATA, WR_RESP, RD_ADDR, RD_DATA} state_t;

state_t stateWR;
state_t stateRD;

//write data fsm
//control flow
always@(posedge clk) begin

 if(~rstn) begin
    stateWR <= IDLE;

  end else begin
    case(stateWR) 
	    IDLE : if (awvalid)
		       stateWR <= WR_DATA;
	    WR_DATA : if(wvalid)
		        stateWR <= WR_RESP;
	    WR_RESP  :
		    if(bready)
		    stateWR <= IDLE;

    endcase
  end

end


//data flow
always@(*) begin
  case(stateWR)
     IDLE: begin
	     wready = 1'b0;
	     awready = 1'b1;
	     bvalid = 1'b0;
	     waddr = awaddr;
	     raddr = araddr;
           end

     WR_DATA: begin
	        wready = 1'b1;
	        awready = 1'b0;
	        tmp_data = wdata;
            end
     WR_RESP: begin
	        wready = 1'b0;
	        bvalid = 1'b1;
  		
		if(waddr ==0) begin
		   op1 = tmp_data;
		   bresp = 2'b00;
		end

	        else
		if(waddr ==1 ) begin
		   op2 <= tmp_data;
		   bresp = 2'b00;
		end

	        else
		if(waddr == 2) begin
		    opCode = tmp_data;
		    bresp = 2'b00;
		 end
		 else
		    bresp = 2'b10;
                
              end
     endcase
end

//Compute result
always@(*) begin
  case(opCode)
	  0: result = op1 + op2;
	  1: result = op1 - op2;
	  2: result = ~op1;
	  3: result = op1 << op2; 

  endcase
end

//read data fsm
always@(posedge clk) begin

 if(~rstn) begin
    stateRD <= IDLE;

  end else begin
    case(stateWR) 
            IDLE : if (arvalid)
                       stateRD <= RD_DATA;
            RD_DATA : if(rready)
                        stateRD <= IDLE;
            
    endcase
  end

end

//data flow
always@(*) begin
  case(stateWR)
     IDLE: begin
             raddr = araddr;
	     arready = 1'b1;
	     rvalid = 1'b0;
	     rresp = 2'b00;
           end

     RD_DATA: begin
               arready = 1'b0;
	       rvalid = 1'b1;

	       if(raddr == 0)
	           rdata = op1;
	       else if(raddr == 1)
		    rdata = op2;
	       else if(raddr == 2)
		     rdata = opCode;
	       else if (raddr == 3)
		     rdata = result;
	       else begin
                  rdata = 'bx;
                  rresp = 2'b10;
	       end
            end
             
     endcase
end



endmodule
