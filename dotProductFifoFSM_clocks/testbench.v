`timescale 1ns/1ps

module testbench; 
	
      parameter ADDRESS_WIDTH =5 ;
      parameter DATA_WIDTH = 32;
      parameter PERIOD_CLK1 = 3.57; //3.7; 270 MGHZ 2
      parameter PERIOD_CLK2 = 3.57; // 270 MGHZ 3.6
      parameter PERIOD_CLK3 = 3.57; // 270 MGHZ 4.5

      localparam VALUE_WIDTH = 8;
      localparam VECTOR_LENGTH= DATA_WIDTH / VALUE_WIDTH;
      localparam N = 2**ADDRESS_WIDTH;

	reg clk1=0;
	reg clk2=0;
	reg clk3=0;
 	reg rstn;
	//writing interface
 	reg WR;
 	reg [ADDRESS_WIDTH-1:0] wraddr;
 	reg [DATA_WIDTH -1:0]  dataIn1;
 	reg [DATA_WIDTH -1:0] dataIn2;
 	reg startProcessing_rd;
        //reading interface
	reg RD;
 	reg [ADDRESS_WIDTH-1:0] rdaddr;
 	wire [2*DATA_WIDTH:0] final_output;
	wire fsm_ready;

 	reg [(1 << ADDRESS_WIDTH)-1:0 ] i;
 	reg [VECTOR_LENGTH-1 : 0] j;
 	reg [(1 << VALUE_WIDTH)-1:0]val;
	reg [2*DATA_WIDTH : 0]  res ;
	integer write_count;

	reg [2*DATA_WIDTH:0]expected_result [0:(2**ADDRESS_WIDTH)-1];
        
	reg [2*DATA_WIDTH:0] new_expected_result [0:(2**ADDRESS_WIDTH)-1];

    	top #(
              .ADDRESS_WIDTH(ADDRESS_WIDTH),
              .DATA_WIDTH(DATA_WIDTH)
    	) 
	DUT(
             .clk1(clk1),
	     .clk2(clk2),
	     .clk3(clk3),
             .rstn(rstn),
       		
	     .WR(WR),
	     .wraddr(wraddr),
             .dataIn1(dataIn1),
             .dataIn2(dataIn2),
	     .startProcessing_rd(startProcessing_rd),
	     .RD(RD),
	     .rdaddr(rdaddr),

	     .final_output(final_output),
	     .fsm_ready(fsm_ready ) 
        );


     // dot product verification function
    function [2*DATA_WIDTH:0] dot_product;
        input [DATA_WIDTH-1:0] v1;
        input [DATA_WIDTH-1:0] v2;
        reg [VECTOR_LENGTH-1:0] k;
        reg [VALUE_WIDTH-1:0] e1, e2;
        begin
            dot_product = 0;
            for (k = 0; k < VECTOR_LENGTH; k = k+1) begin
            e1 = (v1 >> (k*VALUE_WIDTH)) & ((1 << VALUE_WIDTH) - 1);
            e2 = (v2 >> (k*VALUE_WIDTH)) & ((1 << VALUE_WIDTH) - 1);
            dot_product = dot_product + (e1 * e2);
        end
        end
    endfunction

       	
    always #(PERIOD_CLK1/2) clk1 = ~clk1;
    always #(PERIOD_CLK2/2) clk2 = ~clk2;
    always #(PERIOD_CLK3/2) clk3 = ~clk3;

    initial begin
    rstn = 0;
    WR = 0;
    RD = 0;
    val = 0;
    repeat(3)@(posedge clk1);
    rstn = 1;
    @(posedge clk1);
   // wait(fsm_ready === 1'b1);

    //loop to fill the memory
    for (i = 0; i < (2**ADDRESS_WIDTH); i = i + 1) begin
	    wait(fsm_ready === 1'b1);
            wraddr = i;
            WR = 1;
	    @(posedge clk1);
            // Fill dataIn1 and dataIn2 with incremental values
            for (j = 0; j < VECTOR_LENGTH; j = j + 1) begin
                dataIn1[(j*VALUE_WIDTH) +: VALUE_WIDTH] = val;
                dataIn2[(j*VALUE_WIDTH) +: VALUE_WIDTH] = val+2;

		@(posedge clk1);
               
                val = val + 1;
            end
	    expected_result[i] = dot_product(dataIn1, dataIn2);
	    @(posedge clk1);
	    @(posedge clk1);
    end
    // store results in the right order in the vector new results without fifo
    /*
    new_expected_result[0] = expected_result[(2**ADDRESS_WIDTH)-2];

    for (i = 1; i < (2**ADDRESS_WIDTH); i = i + 1) begin
        new_expected_result[i] = expected_result[i-1]; // shift rest
    end
    */

    new_expected_result[0] = expected_result[N-3];   // first value
    new_expected_result[1] = expected_result[N-2];   // second value
    new_expected_result[2] = expected_result[N-1];   // second value

   for(i = 3; i < N; i = i + 1) begin
	new_expected_result[i] = expected_result[i-3];
   end
   
 //------------------------------end filling---------------------------------------
    WR = 0;
    @(posedge clk1);
    startProcessing_rd = 1;

    repeat(150)@(posedge clk1);
    RD = 1;
    rdaddr = 0;
    @(posedge clk3);
     #3000       $finish;

  end

reg [2**ADDRESS_WIDTH-1:0] error_count = 0;

 always @(final_output) begin
	@(posedge clk3); 
        $display("\n[%0t] rdAddr: %0d | DUT output: %0d | Expected: %0d",
             $time, rdaddr, final_output, new_expected_result[rdaddr]);

    if (final_output !== new_expected_result[rdaddr]) begin
	 error_count = error_count + 1;
        $display("ERROR at time %0t: Mismatch detected at address %0d!", $time, rdaddr);
        $display("Expected = %0d", new_expected_result[rdaddr]);
        $display("current = %0d", final_output);
	//*/
    end 
    //increment address for the next read
    if (rdaddr < (2**ADDRESS_WIDTH)-1) begin
	RD = 0;
        @(posedge clk3);
        rdaddr = rdaddr + 1;
        RD = 1;
    end
   // if (error_count !== 0 )

  end

endmodule
