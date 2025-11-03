`timescale 1ns/1ps

module testbench;
    
    parameter DATA_WIDTH = 4;
    parameter DEPTH = 4;

    reg clk=0;
    reg rstn;
    reg [DATA_WIDTH-1:0] dataIn;
    reg [DATA_WIDTH-1:0] value;

    wire full;
    reg WR;
    wire [DATA_WIDTH-1:0] dataOut;
    wire empty;
    reg RD;
    reg[3:0] counter;
   reg initialized = 0;


    reg [3:0] state;
    parameter  IDLE = 2'b00;
    parameter WRITE = 2'b01;
    parameter INCR = 2'b10;
    parameter FULL = 2'b11;


    FIFO #(
        .DATA_WIDTH(DATA_WIDTH),
        .DEPTH(DEPTH)
    ) DUT (
        .clk(clk),
        .rstn(rstn),
        .dataIn(dataIn),
        .full(full),
        .WR(WR),
        .dataOut(dataOut),
        .empty(empty),
        .RD(RD)
    );

    always #2 clk = ~clk;
	

	always @(posedge clk) begin
		state <= IDLE;

		case (state) 
			IDLE : begin
				if (!full) 
					state <= WRITE;
				end

			WRITE : begin
			
				
				if (full)
					state <= FULL;

				else
					state <= INCR;
			
				end

			INCR : begin
			       
			       if (full)
				       state <= FULL;

			       else 
				       state <= WRITE;
				end


			FULL : begin
				if(!full)
					state <= WRITE;
				
			

				else 
					state <= FULL;

				end

	
		endcase	
	end

	always @(state) begin

		case (state)
			WRITE : begin
				WR <= 1;
				
			 end

			 INCR : begin
				WR <= 0;
				dataIn <= dataIn + 1;
			
			end
		
		endcase

	end

/*

	always @(posedge clk, full) begin

                                  
                  if (!full) begin
                          

                          dataIn <= dataIn + 1;
			  WR <= 1;
	        end
             
                  else
                          WR <= 0;
		   end
*/          

	always @(posedge clk) begin
		
		if(!empty && counter == 6 ) 
			RD <= 1;
			

		else
			RD <= 0;
		counter <= counter + 1;
	end
		

always @(posedge clk) begin
    if (!initialized) begin
        counter <= 0;
        initialized <= 1;
    end
end

    initial begin
        
        rstn = 0;
        WR = 0;
        RD = 0;
//	counter = 0;
        dataIn = 0;
	value = 0;

        #5;
        rstn = 1;


	#5000
        $finish;
    end

    
    initial begin
        $monitor("Time=%0t rstn=%b WR=%b RD=%b dataIn=%h dataOut=%h full=%b empty=%b",
                 $time, rstn, WR, RD, dataIn, dataOut, full, empty);
    end

endmodule
