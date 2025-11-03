`timescale 1ns/1ps


module alu 
#(
	parameter DATA_WIDTH = 9,
	parameter OPCODE_WIDTH = 2,
	parameter STATE_WIDTH = 3
)
(
	input clk,
	input rstn,

	input [OPCODE_WIDTH-1:0] opcode,
	input [DATA_WIDTH-2:0] opa,
	input [DATA_WIDTH-2:0] opb,

	input wr,
	output reg done, 
	output reg status,
	output reg [DATA_WIDTH-1:0] res

);

reg [STATE_WIDTH-1:0] state;

parameter IDLE = 3'b000;
parameter DEC = 3'b001;
parameter ERR = 3'b010;
parameter ADD = 3'b011;
parameter SUB = 3'b100;
parameter SHR = 3'b101;
parameter SHL = 3'b110;
parameter DONE = 3'b111;




//state transition logic

always @(posedge clk) begin

	if(~rstn)
		state <= IDLE;
	else begin
		case(state)
			IDLE: begin
				if(wr)
					state <= DEC;

				end
			DEC: begin
				if(opcode == 2'b00)
					state <= ADD;

				else if(opcode == 2'b01)
					state <= SUB;

				else if(opcode == 2'b10)
					state <= SHR;

				else if(opcode == 2'b11)
					state <= SHL;

				else 
					state <= ERR;

				end

			ERR: begin
				state <= IDLE;

				end

			ADD: begin
				state <= DONE;

				end

			SUB: begin
				state <= DONE;

				end

			SHL: begin
				state <= DONE;

				end
			
			SHR: begin
				state <= DONE;

				end

			DONE: begin
				state <= IDLE;


				end

		endcase
	end

end

//ALU logic

always@(state) begin

	case (state)

	IDLE: begin
		
		done = 1;
              end
        
	 DEC: begin
		 done = 0;

		
                end

         ERR:  begin
		 status = 0;
		 done = 1;
                                
               end                

          ADD: begin
		  res = opa + opb;

                 end

          SUB: begin

		  res = opa - opb;

                  end

           SHL: begin

		   res = opa << opb;

                   end

           SHR: begin

		    res = opa >> opb;

                   end

           DONE: begin

		   done = 1;
		   status = 1;

                    end
	endcase

end


endmodule
