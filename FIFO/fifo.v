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
		
		reg [DEPTH-1:0] wr_ptr ;
		reg [DEPTH-1:0] rd_ptr ;
		reg rd_cnt ;
		reg wr_cnt ;
		reg [DATA_WIDTH-1:0] mem [0:DEPTH-1];

		always @(posedge clk) begin

			if(!rstn)begin
				rd_ptr <= 0;
				rd_cnt <=0;
			end
			else begin

				if(RD == 1)  begin
					if (empty==0) begin
						dataOut <= mem[rd_ptr];
						
						if(rd_ptr == DEPTH -1 ) begin
							rd_ptr <=0;
							if(rd_cnt == 0)
								rd_cnt <=1;
							else
								rd_cnt <= 0;
						end
						else
					   	rd_ptr = rd_ptr + 1 ;
					end
				end
			end
		end
				
				
		always @(posedge clk) begin

			if(!rstn)begin
				wr_ptr <= 0;
				wr_cnt <=0;
			end
			else begin
				if (WR==1) begin
					if(full==0) begin
						mem[wr_ptr] <= dataIn;

						if (wr_ptr == DEPTH -1) begin
							wr_ptr <= 0;

							if(wr_cnt ==0)
								wr_cnt <=1;
							else
								wr_cnt <= 0;
						end
						else 
					   		wr_ptr = wr_ptr +1;
				
	
					end
				end
			end
			
			
		end
		
		assign full  = (wr_ptr == rd_ptr && wr_cnt != rd_cnt) ;
		assign empty = (wr_ptr == rd_ptr && wr_cnt == rd_cnt) ;


	
endmodule
