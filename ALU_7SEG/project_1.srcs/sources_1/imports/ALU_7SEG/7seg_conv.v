`timescale 1ns/1ps

module segConv
#(
        parameter DATA_WIDTH = 3,
        parameter OPCODE_WIDTH = 2,
	parameter RESULT_WIDTH = 7
)

(
	input [OPCODE_WIDTH-1:0] opcode,
        input [DATA_WIDTH-1:0] opa,
        input [DATA_WIDTH-1:0] opb,
        input [DATA_WIDTH-1:0] aluRes,
	output reg [RESULT_WIDTH-1:0] opcode7seg,
	output reg [RESULT_WIDTH-1:0] opa7seg,
	output reg [RESULT_WIDTH-1:0] opb7seg,
	output reg [RESULT_WIDTH-1:0] aluRes7seg
);

//	wire [DATA_WIDTH-1:0] aluReswire;

//	assign aluReswire = aluRes;

	segCtrl #(.DATA_WIDTH(DATA_WIDTH),.RESULT_WIDTH(RESULT_WIDTH))
 		 segCtrlopcode(
			.dataIn(opcode),
			.dataOut(opcode7seg)
		);

	segCtrl #(.DATA_WIDTH(DATA_WIDTH),.RESULT_WIDTH(RESULT_WIDTH))
		segCtropa(
			.dataIn(opa),
                	.dataOut(opa7seg)
		);

	segCtrl #(.DATA_WIDTH(DATA_WIDTH),.RESULT_WIDTH(RESULT_WIDTH))
		segCtropb(
                	.dataIn(opb),
                	.dataOut(opb7seg)
        	);

	segCtrl #(.DATA_WIDTH(DATA_WIDTH),.RESULT_WIDTH(RESULT_WIDTH))
		segCtraluRes(
			.dataIn(aluResRESULT_WIDTH),
                	.dataOut(aluRes7seg)
		);

endmodule
