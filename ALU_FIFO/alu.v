`timescale 1ns/1ps
module ALU 
#(
	parameter DATA_WIDTH = 9,
	parameter OPCODE_WIDTH = 2,
	parameter STATE_WIDTH = 3
)
(
	input clk,
	input rstn,
	input [OPCODE_WIDTH-1:0] opcode,
	input [DATA_WIDTH-1:0] opa,
	input [DATA_WIDTH-1:0] opb,
	input wr,
	input full,
	output reg done, 
	output reg status,
	output reg [DATA_WIDTH:0] res
);
reg [OPCODE_WIDTH-1:0] opcodeTemp;
reg [DATA_WIDTH-1:0] opaTemp;
reg [DATA_WIDTH-1:0] opbTemp;
reg [STATE_WIDTH-1:0] state;

parameter IDLE = 3'b000;
parameter DEC = 3'b001;
parameter ERR = 3'b010;
parameter ADD = 3'b011;
parameter SUB = 3'b100;
parameter SHR = 3'b101;
parameter SHL = 3'b110;
parameter WAIT = 3'b111;

//state transition logic
always @(posedge clk) begin
	if(~rstn)
		state <= IDLE;
	else begin
		case(state)
			IDLE: begin
				if(wr)
					opaTemp <= opa;
			     		opbTemp <= opb;
			     		opcodeTemp <= opcode;
					state <= DEC;
				end

			DEC: begin
				if(opcodeTemp == 2'b00)
					state <= ADD;
				else if(opcodeTemp == 2'b01)
					state <= SUB;
				else if(opcodeTemp == 2'b10)
					state <= SHR;
				else if(opcodeTemp == 2'b11)
					state <= SHL;
				else 
					state <= ERR;
				end

			ERR: begin
				state <= IDLE;
				end

			ADD: begin
				state <= WAIT;
				end

			SUB: begin
				state <= WAIT;
				end

			SHL: begin
				state <= WAIT;
				end
			
			SHR: begin
				state <= WAIT;
				end

			WAIT: begin
				  if (full == 0)
                   			 state <=IDLE;
				end
		endcase
	end
end

//ALU logic
always@(state) begin
	case (state)

	IDLE: begin
		done <= 1;
		status <= 1;
              end
        
	 DEC: begin
		 done <= 0;
                end

         ERR:  begin
		 status <= 0;
		 done <= 1;            
               end                

          ADD: begin
		  res <= opaTemp + opbTemp;
                 end

          SUB: begin
		  res <= opaTemp - opbTemp;
                  end

           SHL: begin
		   res <= opaTemp << opbTemp;
                   end

           SHR: begin
		    res <= opaTemp >> opbTemp;
                   end
	endcase

end
endmodule
