`timescale 1ns/1ps

module top

#(
     parameter DATA_WIDTH = 3,
     parameter OPCODE_WIDTH = 2,
     parameter RESULT_WIDTH = 7
)

(
     input clk,
     //input rst,
     input rstn,
     input [OPCODE_WIDTH-1:0] opcode,
     input [DATA_WIDTH-1:0] opa,
     input [DATA_WIDTH-1:0] opb,

     output  [RESULT_WIDTH-1:0] opcode7seg,
     output  [RESULT_WIDTH-1:0] opa7seg,
     output  [RESULT_WIDTH-1:0] opb7seg,
     output  [RESULT_WIDTH-1:0] aluRes7seg

);

	wire [DATA_WIDTH-1:0] aluRes;

	wire [DATA_WIDTH-1:0] aluReswire;
        assign aluReswire = aluRes;


	alu #(.DATA_WIDTH(DATA_WIDTH),.OPCODE_WIDTH(OPCODE_WIDTH))

	   alutop(
	   	.clk(clk),
		.rstn(rstn),
		.opcode(opcode),
		.opa(opa),
		.opb(opb),
		.aluRes(aluRes)
	   );

	segConv #(.DATA_WIDTH(DATA_WIDTH),.OPCODE_WIDTH(OPCODE_WIDTH),.RESULT_WIDTH(RESULT_WIDTH))
	
	   segContop(
		.opcode(opcode),
                .opa(opa),
                .opb(opb),
                .aluRes(aluRes),
     		.opcode7seg(opcode7seg),
		.opa7seg(opa7seg),
		.opb7seg(opb7seg),
		.aluRes7seg(aluRes7seg)		
	   );

endmodule

