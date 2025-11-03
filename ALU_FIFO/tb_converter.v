`timescale 1ns/1ps




module tb_converter;

	parameter DATA_WIDTH = 4;
        parameter OPCODE_WIDTH = 2;

	reg [(2*DATA_WIDTH)+OPCODE_WIDTH-1 : 0] fifo;
    	wire [DATA_WIDTH-1:0] opA;
   	wire [DATA_WIDTH-1:0] opB;
   	wire [OPCODE_WIDTH-1:0] opCode;


	Converter #(
		.DATA_WIDTH(DATA_WIDTH),
		.OPCODE_WIDTH(OPCODE_WIDTH)
	) DUT (
		.fifo(fifo),
		.opA(opA),
		.opB(opB),
		.opCode(opCode)
	);

	initial begin
		fifo = 10'b1111110100;

		#2;
	       	$display("fifo = %b | opA = %b | opB = %b | opCode = %b", fifo, opA, opB, opCode);


		fifo = 10'b1111110111;

                #2;
	       	$display("fifo = %b | opA = %b | opB = %b | opCode = %b", fifo, opA, opB, opCode);



	end

	endmodule 
