`timescale 1ns/1ps

module mainMemorycopy

	(
       
        input clk,

	//write interface
	
        input [2:0] local_addrIn,
        input [63:0]  dataIn,
	input [1:0] WR,

	//read interface
	
	input [3:0] addrOut,
       	output reg [63:0] dataOut,
	input RD 
);

	wire [3:0] global_addrIn;
	wire ismem1;
	wire ismem2;

	assign global_addrIn = {1'b0, local_addrIn};

	Encoder encode(
		.select(WR),
    		.addrIn(local_addrIn),
    		.addrEncoded(global_addrIn),
	        .mem1(ismem1),
		.mem2(ismem2)	
	);


	Memory #(
		.DATA_WIDTH(64),
        	.ADDR_WIDTH(3)
	) sub_memory1(
	
	.clk(clk),
        .addrIn(global_addrIn),
        .dataIn(dataIn),
        .WR(ismem1),
        .addrOut(addrOut),
        .dataOut(dataOut),
        .RD(RD)
	);

	Memory #(
                .DATA_WIDTH(64),
                .ADDR_WIDTH(3)
        ) sub_memory2(

        .clk(clk),
        .addrIn(global_addrIn),
        .dataIn(dataIn),
        .WR(ismem2),
        .addrOut(addrOut),
        .dataOut(dataOut),
        .RD(RD)

        );



endmodule

