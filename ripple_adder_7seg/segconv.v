`timescale 1ns/1ps

module segConv
#(
        parameter DATA_WIDTH = 3,
	parameter RESULT_WIDTH = 7
)

(
        input [DATA_WIDTH-1:0] opa,
        input [DATA_WIDTH-1:0] opb,
        input [DATA_WIDTH-1:0] sum,
	
	output  [RESULT_WIDTH-1:0] opa7seg,
	output  [RESULT_WIDTH-1:0] opb7seg,
	output  [RESULT_WIDTH-1:0] sum7seg
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
		segCtrsum(
			.dataIn(sum),
                	.dataOut(sum7seg)
		);

endmodule
