`timescale 1ns/1ps

module cpu
#(
   parameter DATA_WIDTH = 10,
   parameter ADDRESS_WIDTH =3
)
(
   input clk,
   input rstn,
   input start,

   //instruction interface
   input [DATA_WIDTH-1:0] inst,
   output reg [ADDRESS_WIDTH-1:0]  pc,

   // data interface
   input [DATA_WIDTH-1:0] data_opA,
   input [DATA_WIDTH-1:0] data_opB,
   output reg [ADDRESS_WIDTH-1:0] addr_opA,
   output reg [ADDRESS_WIDTH-1:0] addr_opB,
   output reg [ADDRESS_WIDTH-1:0] addr_Res,
   output reg [DATA_WIDTH-1:0] data_Res,

   // control signal
   output reg start_fetch,
   output wire readA,
  output wire readB,
   output reg write_Res
);


  parameter IDLE = 0;
  parameter FETCH = 1;
  parameter DEC = 2;
  parameter WAIT_OPA =3;
  parameter LOAD_OPA= 4;
  parameter WAIT_OPB =5;
  parameter LOAD_OPB = 6;
  parameter EXEC = 7;
  parameter WAIT_RES = 8;
  parameter WRITE_BACK = 9;

  reg [2:0] state;

  reg [ADDRESS_WIDTH-1:0] pc_r=0;
  reg [DATA_WIDTH-1:0] inst_r;

  // addresses decoded
  reg  opCode;
  reg [DATA_WIDTH-8:0] opA;
  reg [DATA_WIDTH-8:0] opB;
 // reg [DATA_WIDTH-8:0] addr_Res_r;
//  reg [ADDRESS_WIDTH-1:0] addr_opB_r;
 // data 
  reg [DATA_WIDTH-1:0]  data_opA_r;
  reg [DATA_WIDTH-1:0]  data_opB_r;
  reg [DATA_WIDTH-1:0]  result;

 // control register
  reg fetch_done;
  reg dec_done ;
  reg load_opA_done;
  reg load_opB_done;
  reg exec_done;                        
  reg write_back_done; 



   //always block that controls transitions between states
  always@(posedge clk ) begin

	  if(~rstn) begin
		  pc <= 0;
		  start_fetch <= 1;
		  state <= IDLE;

	  end else begin
		  case (state)
			  IDLE:begin
				 if(write_back_done)
					 state <= FETCH;
                               end

			 FETCH:begin
				  if(start)
				     state <= DEC;
 				end


			 DEC: begin
				  if(fetch_done)
				  	state <= WAIT_OPA; //LOAD_OPA;
			  
			       end
			 WAIT_OPA : begin 
				  if(dec_done )
				        state <= LOAD_OPA;
				end

			 LOAD_OPA:  begin
				  
				      if( opCode == 1'b0)
				           state <= WAIT_OPB;//   LOAD_OPB;
				      else if (opCode == 1'b1)					
					   state <= EXEC;
                         	   end

		          WAIT_OPB: begin
				      if(load_opA_done )
					  state <= LOAD_OPB;
			          end

		          LOAD_OPB: begin
				 // if  (load_opB_done)
                              		 state <= EXEC;
            			    end

			  EXEC: begin
				  state <= WAIT_RES;
				//  if (load_opB_done || load_opA_done  )
				 	// 	state <= WRITE_BACK;
			       end

			  WAIT_RES: begin
				  if(write_Res)
                                       state <= WRITE_BACK;
                                   end

		          WRITE_BACK: begin 
				        if(exec_done )
				   	    state <= IDLE;
	                              end
	      	endcase

	  end  
  end

  assign read = dec_done;
  assign readB = load_opA_done;
 // assign start_exec = load_opB_done ;

  always @(*) begin
	  case(state)
		  IDLE : begin
			  pc_r <= pc;

			  addr_opA <= 0;
                          addr_opB <= 0;
                          addr_Res <=0;
                          data_Res <= 0;
                          
			  fetch_done <=0;
			  dec_done <=0;
			  load_opA_done <=0;
			  load_opB_done <= 0;
			  exec_done <=0;
			  write_Res <= 0;
			  write_back_done <= 0;
		//	  start_fetch <= 1;
		        end

		  FETCH : begin
			  inst_r <= inst;
			  fetch_done <= 1;
			  start_fetch <= 0;
		         end

		  DEC : begin
			  opCode <= inst_r[0];
			  addr_opA <= inst_r[3:1];
			  addr_opB <= inst_r[6:4];
                          addr_Res <= inst_r[9:7];
			  dec_done <= 1;
		        end

		  LOAD_OPA: begin
	                      
			           data_opA_r <= data_opA;
				  // data_opA_r <= data_op;
			           load_opA_done <= 1;
				   //addr_op <= addr_opB_r;
			      
		  	   end

	          
		 LOAD_OPB: begin
			   
			          data_opB_r <= data_opB;
			        // data_opB_r <= data_op;
			         load_opB_done <= 1;
			   
		 	   end

	          EXEC : begin
			   dec_done <= 0;
			   if(opCode == 0)
				     data_Res <= data_opA_r + data_opB_r;
			    else if (opCode == 1)
				     data_Res <= ~(data_opA_r);
			     write_Res <= 1;
		         end

		   WRITE_BACK : begin
			           write_back_done <= 1;
				   pc <= pc+1;
				   start_fetch <= 1;

		   		end
		endcase
  end

endmodule
