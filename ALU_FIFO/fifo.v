`timescale 1ns/1ps

module FIFO

#(
	parameter DATA_WIDTH = 4,
	parameter DEPTH = 4
)
(
	input clk,
	input rstn,
	input  [DATA_WIDTH-1:0] dataIn,
	output wire  full,
	input  WR,
	output reg [DATA_WIDTH-1:0] dataOut,
	output wire  empty,
	input RD
	
	);	
		reg [1:0] wr_ptr ;
		reg [1:0] rd_ptr ;
		reg rd_cnt ;
		reg wr_cnt ;
		reg [DATA_WIDTH-1:0] mem [0:DEPTH-1];

		always @(posedge clk) begin
			if(!rstn)begin
				rd_ptr <= 0;
				rd_cnt <=0;
			end
			else begin
				if(RD && !empty)  begin
						dataOut <= mem[rd_ptr];
						rd_ptr <= rd_ptr + 1 ;
			
						if(rd_ptr == DEPTH -1 ) 
						      rd_cnt <= !rd_cnt;			   	
				end
			end
		end
								
		always @(posedge clk) begin
			if(!rstn)begin
				wr_ptr <= 0;
				wr_cnt <=0;
			end
			else begin
				if (WR && !full) begin
						mem[wr_ptr] <= dataIn;
						wr_ptr <= wr_ptr +1;

						if (wr_ptr == (DEPTH -1)) 	
							wr_cnt <= !wr_cnt;
				end
			end			
		end
		
		assign full  = (wr_ptr == rd_ptr && wr_cnt != rd_cnt) ;
		assign empty = (wr_ptr == rd_ptr && wr_cnt == rd_cnt) ;
	
endmodule
