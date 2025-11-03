`timescale 1ns/1ps




module Converter

#(
        parameter DATA_WIDTH = 4,
	parameter OPCODE_WIDTH = 2
)

(           
    input [(2*DATA_WIDTH)+OPCODE_WIDTH-1 : 0] fifo,         
    output  [DATA_WIDTH-1:0] opA,
    output  [DATA_WIDTH-1:0] opB,
    output  [OPCODE_WIDTH-1:0] opCode

    
);
	assign opA = fifo [(2*DATA_WIDTH) + OPCODE_WIDTH-1 :  DATA_WIDTH + OPCODE_WIDTH] ;
	assign opB = fifo [DATA_WIDTH + OPCODE_WIDTH-1 : OPCODE_WIDTH];
	assign opCode = fifo [OPCODE_WIDTH-1 : 0];

endmodule
