`timescale 1ns/1ps
module top 
	#(parameter ADDRESS_WIDTH = 4,
	parameter ADDRESS_WIDTH_SM = 2,	
	parameter DATA_WIDTH = 8)
	(
	input WR,
	input RD,
	input clk,
	input [ADDRESS_WIDTH-1:0] wraddr,
	input [ADDRESS_WIDTH-1:0] rdaddr,
	input [(DATA_WIDTH-1):0]  dataIn,
        output reg [(DATA_WIDTH-1):0] dataOut);
	
	localparam NUM_MEMS = (2**ADDRESS_WIDTH / 2**ADDRESS_WIDTH_SM) ;
	
	reg [NUM_MEMS-1:0] WR_MEMS ;
	reg [NUM_MEMS-1:0] RD_MEMS ;
	reg [DATA_WIDTH-1:0] dataIn_MEMS [NUM_MEMS-1:0];
	wire [DATA_WIDTH-1:0] dataOut_MEMS [NUM_MEMS-1:0];
	reg [ADDRESS_WIDTH_SM-1:0] rdaddr_MEMS [NUM_MEMS-1:0];
	reg [ADDRESS_WIDTH_SM-1:0] wraddr_MEMS [NUM_MEMS-1:0];

	wire[ADDRESS_WIDTH_SM-1:0]  idx_wr;
	wire[ADDRESS_WIDTH_SM-1:0]  idx_rd;

	assign idx_wr = wraddr / NUM_MEMS;
	assign idx_rd = rdaddr / NUM_MEMS;	
	 

	always @(posedge clk) begin
		if(WR) begin
			WR_MEMS[idx_wr] <= WR;
			wraddr_MEMS[idx_wr] <= wraddr[ADDRESS_WIDTH_SM-1:0] ;
		//	wraddr_MEMS[idx_wr] <= wraddr[ADDRESS_WIDTH-1 % ADDRESS_WIDTH_SM-1] ;
			dataIn_MEMS[idx_wr] <= dataIn;
		end
		else begin
			WR_MEMS[idx_wr] <= 0;
		end
	end

	 always @(posedge clk) begin
                if(RD) begin
                         RD_MEMS[idx_rd] <= RD;
                         rdaddr_MEMS[idx_rd] <= rdaddr [ADDRESS_WIDTH_SM-1:0];
                         dataOut <= dataOut_MEMS[idx_rd];
                 end

		 else begin
			 RD_MEMS[idx_rd] <= 0;
		 end

                 

        end

	genvar i;
	generate

		for(i= 0; i < NUM_MEMS; i = i+1)
		begin
			memory #(
			.ADDRESS_WIDTH(ADDRESS_WIDTH_SM),
			.DATA_WIDTH(DATA_WIDTH) )
			MEM  (
				.clk(clk),
				.WR(WR_MEMS[i]),
				.wraddr(wraddr_MEMS[i]),
				.dataIn( dataIn_MEMS[i]),
				.RD(RD_MEMS[i]),
      				.rdaddr(rdaddr_MEMS[i]),
				.dataOut(dataOut_MEMS[i])
			);
			
		end
	endgenerate
endmodule
