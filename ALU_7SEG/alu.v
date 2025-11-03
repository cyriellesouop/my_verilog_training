`timescale 1ns/1ps


module alu 
#(
	parameter DATA_WIDTH = 3,
	parameter OPCODE_WIDTH = 2
)
(
	input clk,
	input rstn,
	input [OPCODE_WIDTH-1:0] opcode,
	input [DATA_WIDTH-1:0] opa,
	input [DATA_WIDTH-1:0] opb,
	output reg [DATA_WIDTH-1:0] aluRes

);

//state transition logic

always @(posedge clk) begin

	if(~rstn)
		aluRes = 0;
	else begin
		case(opcode)
			2'b00: aluRes <= opa | opb;
			2'b01: aluRes <= opa & opb;
			2'b10: aluRes <= opa ^ opb;
			2'b11: aluRes <= opa ^~ opb;

		default : aluRes = 0;
		endcase
	end
end
endmodule
