`timescale 1ns/1ps


module ALUFIFO 
	#(
		parameter DATA_WIDTH = 4,
		parameter OPCODE_WIDTH = 2,
	//	parameter FIFO_WIDTH = (2*DATA_WIDTH)+OPCODE_WIDTH,
		parameter STATE_WIDTH = 3,
		parameter DEPTH = 4

	)
	(
		input clk,
		input rstn,
		input [(2*DATA_WIDTH)+OPCODE_WIDTH-1 : 0] packetIn,
		input wr,
		input rd,
		output  [DATA_WIDTH-1:0] dataOut
	);

	parameter FIFO_WIDTH = (2*DATA_WIDTH) + OPCODE_WIDTH;
	wire [DATA_WIDTH-1:0] opA;
        wire [DATA_WIDTH-1:0] opB;
        wire [OPCODE_WIDTH-1:0] opCode;


	wire [FIFO_WIDTH-1:0]  packetOut; 
	reg rd_fifoIn;
	
	wire done;
	wire status;

	wire [DATA_WIDTH-1:0] res;
	wire full;
	wire empty;
	wire fullOut;
	wire emptyOut;

	reg wr_alu;
	
	//state of the system
	
	reg [STATE_WIDTH-1:0] state;
	parameter IDLE = 2'b00;
        parameter READ_FIFO = 2'b01;
        parameter PROCESS_ALU = 2'b10;
        parameter WRITE_RESULT = 2'b11;	

	//to validate the sending of input data in the system (whenthe FIFO is not full) and the reading of output (FIFO out is not empty)
	wire can_write_in = wr && !full;
    	wire can_read_out = rd && !emptyOut;
	



	  Converter #( .DATA_WIDTH(DATA_WIDTH), .OPCODE_WIDTH(OPCODE_WIDTH) )
                converter1 (
                .fifo(packetOut),
                .opA(opA),
                .opB(opB),
                .opCode(opCode)
                 );


	  FIFO  #(.DATA_WIDTH(FIFO_WIDTH), .DEPTH(DEPTH))
              fifoIn  (
                .clk(clk),
                .rstn(rstn),
                .dataIn(packetIn),
                .full(full),
                .WR(can_write_in),
                .dataOut(packetOut),
                .empty(empty),
                .RD(rd_fifoIn)
                 );



	ALU  #(.OPCODE_WIDTH(OPCODE_WIDTH), .DATA_WIDTH(DATA_WIDTH), .STATE_WIDTH(STATE_WIDTH))
   	       alu(
        	.clk(clk), 
		.rstn(rstn), 
		.opa(opA), 
		.opb(opB), 
		.opcode(opCode) ,
        	.wr(wr_alu),
		.done(done), 
		.status(status), 
		.res(res)
    		);



	 FIFO  #(.DATA_WIDTH(DATA_WIDTH), .DEPTH(DEPTH))
	 	fifoOut (
        	.clk(clk),
       		.rstn(rstn),
        	.dataIn(res),
       	 	.full(fullOut),
       		.WR(can_read_out),
        	.dataOut(dataOut),
        	.empty(emptyOut),
       		.RD(rd)
  		 );



	
	always @(posedge clk) begin

		if(!rstn)
			state <= IDLE;
		else begin
			case(state)
				IDLE:
				       	if (!empty) 
						state = READ_FIFO;
            			READ_FIFO: 
					state = PROCESS_ALU;
            			PROCESS_ALU: 
					if (done) 
						state = WRITE_RESULT;
           			 WRITE_RESULT:
                			if (!fullOut)
					       	state = IDLE;

			endcase

		end

	end
		 
	
	always @(state) begin
        	case (state)
            		IDLE: begin
               			 rd_fifoIn = 0;
               			 wr_alu = 0;
            		end
            		READ_FIFO: begin
                		rd_fifoIn = 1;
                		wr_alu = 0;
            		end
            		PROCESS_ALU: begin
                		rd_fifoIn = 0;
                		wr_alu = 1;
            		end
            		WRITE_RESULT: begin
                		rd_fifoIn = 0;
                		wr_alu = 0;
            		end
        	endcase
    	end

endmodule
