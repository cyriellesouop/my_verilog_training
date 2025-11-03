`timescale 1ns/1ps


module ALUFIFO 
	#(
		parameter DATA_WIDTH = 4,
		parameter OPCODE_WIDTH = 2,
		parameter STATE_WIDTH = 3,
		parameter DEPTH = 4

	)
	(
		input clk,
		input rstn,
		input [(2*DATA_WIDTH)+OPCODE_WIDTH-1 : 0] packetIn,
		input wr,
		input rd,
		output full,
		output empty,
		output  [DATA_WIDTH:0] dataOut
	);

	// wires for FIFOIN
	wire [(2*DATA_WIDTH)+OPCODE_WIDTH-1 : 0] fifoIn_packetOut;
	wire fifoIn_empty;
	wire fifoIn_rd;
	wire ready;
    wire fifoIn_wr;	
	//wires for converter
	wire [DATA_WIDTH-1:0] opA;
	wire [DATA_WIDTH-1:0] opB;
	wire [OPCODE_WIDTH-1 : 0] opCode;

	//wires for ALU
	wire alu_wr;
	wire done;
	wire status;
	wire[DATA_WIDTH : 0] res;

	//wires for fifoOut
	wire fifoOut_wr;
	wire fifoOut_empty;
	wire fifoOut_full;

	//register for ALU
	reg fifoIn_rd_delay;
	reg done_delay;
    reg status_delay;

	assign ready = !fifoOut_full;
	assign fifoIn_wr= wr &&  ready ;
	 
	FIFO  #(.DATA_WIDTH((2*DATA_WIDTH)+OPCODE_WIDTH), .DEPTH(DEPTH))
              fifoIn  (
                .clk(clk),
                .rstn(rstn),
                .dataIn(packetIn),
                .full(full),
                .WR(fifoIn_wr),
                .dataOut(fifoIn_packetOut),
                .empty(fifoIn_empty),
                .RD(fifoIn_rd)
                 );  
	
	assign fifoIn_rd = !fifoIn_empty && done ;
	       
	Converter #( .DATA_WIDTH(DATA_WIDTH), .OPCODE_WIDTH(OPCODE_WIDTH) )
                converter (
                .fifo(fifoIn_packetOut),
                .opA(opA),
                .opB(opB),
                .opCode(opCode)
    
             );
             

//	always @(posedge clk) begin
//   		 if (!rstn)
//        		fifoIn_rd_delay <= 0;
//    		else
//       			 fifoIn_rd_delay <= fifoIn_rd;
//	end

//	always @(posedge clk ) begin
//	       	if (!rstn)
//       			 status_delay <= 0;
//		else
//       			 status_delay <= status;
//		end
		
//    always @(posedge clk) begin
//        if (!rstn)
//       			 done_delay <= 0;
//		else
//       			 done_delay <= done;
//		end


	//assign alu_wr = fifoIn_rd && done_delay;
	assign alu_wr = fifoIn_rd;

	ALU  #(.OPCODE_WIDTH(OPCODE_WIDTH), .DATA_WIDTH(DATA_WIDTH), .STATE_WIDTH(STATE_WIDTH))
   	       alu(
        	.clk(clk), 
		.rstn(rstn), 
		.opa(opA), 
		.opb(opB), 
		.opcode(opCode) ,
        	.wr(alu_wr),
		.full(fifoOut_full),
		.done(done), 
		.status(status), 
		.res(res)
    		);



	
	//assign fifoOut_wr = (!fifoOut_full) && done_delay 
	assign fifoOut_wr = (!fifoOut_full) && done;



	 FIFO  #(.DATA_WIDTH(DATA_WIDTH+1), .DEPTH(DEPTH))
	 	fifoOut (
        	.clk(clk),
       		.rstn(rstn),
        	.dataIn(res),
       	 	.full(fifoOut_full),
       		.WR(fifoOut_wr),
        	.dataOut(dataOut),
        	.empty(empty),
       		.RD(rd)
  		 );


endmodule
