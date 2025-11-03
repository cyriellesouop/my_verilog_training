`timescale 1ns/1ps

module mainMemory
	(
	//write interface1
	input clk1,
        input [2:0] addrIn1,
        input [63:0]  dataIn1,
	input WR1,
	//write interface2
        input clk2,
        input [2:0] addrIn2,
        input [63:0] dataIn2,
        input WR2,
	//read interface
	input clk3,
	input [3:0] addrOut,
       	output reg [63:0] dataOut,
	input RD 
);

	wire [3:0] addrEncoded1;
	wire [3:0] addrEncoded2;

	Encoder1 encode1(

		.addrIn(addrIn1),
		.addrEncoded(addrEncoded1)
	);

	Encoder2 encode2(

                .addrIn(addrIn2),
                .addrEncoded(addrEncoded2)
        );
	
	reg [63:0] word [0:15];
        always @(posedge clk1) begin

                if (WR1)
                        word[addrEncoded1] <= dataIn1;
        end

	always @(posedge clk2) begin
		  if(WR2)
                        word[addrEncoded2] <= dataIn2;
	end

	always @(posedge clk3) begin
		if(RD)
                        dataOut <= word[addrOut];
	end

endmodule

