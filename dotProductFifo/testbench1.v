`timescale 1ns/1ps

module testbench; 
	
      parameter ADDRESS_WIDTH =5 ;
      parameter DATA_WIDTH = 16;
      parameter PERIOD = 4;
      localparam VALUE_WIDTH = 4;
      localparam VECTOR_LENGTH= DATA_WIDTH / VALUE_WIDTH;
      localparam N = 2**ADDRESS_WIDTH;

	reg clk=0;
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
             .clk(clk),
             .rstn(rstn),
       		
	     .WR(WR),
	     .wraddr(wraddr),
             .dataIn1(dataIn1),
             .dataIn2(dataIn2),
	     .startProcessing_rd(startProcessing_rd),
	     .RD(RD),
	     .rdaddr(rdaddr),

	     .final_output(final_output)
        );


     // dot product verification function
    function integer dot_product;
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

       	
    always #(PERIOD/2) clk = ~clk;
    initial begin
    rstn = 0;
    WR = 0;
    RD = 0;
   // rdaddr =0;
    val = 0;
    repeat(3)@(posedge clk);
    rstn = 1;
 //   rdaddr =0;
    @(posedge clk);
    for (i = 0; i < (2**ADDRESS_WIDTH); i = i + 1) begin
            wraddr = i;
            WR = 1;
	    @(posedge clk);
            // Fill dataIn1 and dataIn2 with incremental values
            for (j = 0; j < VECTOR_LENGTH; j = j + 1) begin
                dataIn1[(j*VALUE_WIDTH) +: VALUE_WIDTH] = val;
                dataIn2[(j*VALUE_WIDTH) +: VALUE_WIDTH] = val + 1;

		@(posedge clk);
               
                val = val + 1;
            end
	    expected_result[i] = dot_product(dataIn1, dataIn2);
	   // expected_result[i] = dot_product(dataIn1, dataIn2);
	    @(posedge clk);
          //  $display("\n [%0t]  wraddr %0d:  dataIn1 %b:  dataIn2: %b, expected_result%d:", $time,  wraddr,  dataIn1, dataIn2, expected_result[i]);
            @(posedge clk);
    end

    // store results in the right order in the vector new results without fifo
    /*
    new_expected_result[0] = expected_result[(2**ADDRESS_WIDTH)-2];

    for (i = 1; i < (2**ADDRESS_WIDTH); i = i + 1) begin
        new_expected_result[i] = expected_result[i-1]; // shift rest
    end
    */

    new_expected_result[0] = expected_result[N-2];   // first value
    new_expected_result[1] = expected_result[N-1];   // second value

   for(i = 2; i < N; i = i + 1) begin
	new_expected_result[i] = expected_result[i-2];
   end
   
 //------------------------------end filling---------------------------------------
   WR = 0;
    @(posedge clk);
    startProcessing_rd = 1;
    RD = 1;
    rdaddr = 0;
    //@(posedge clk);
    repeat(20)@(posedge clk);

     #2000      $finish;

  end

reg [2**ADDRESS_WIDTH-1:0] error_count = 0;

 always @(final_output) begin
	 @(posedge clk);
	 RD = 1;
	@(posedge clk); 
        $display("\n[%0t] rdAddr: %0d | DUT output: %0d | Expected: %0d",
             $time, rdaddr, final_output, new_expected_result[rdaddr]);

      //  @(posedge clk);//increment address for the next read
//    if (1'b0 < (2**ADDRESS_WIDTH)-1) begin
       // RD = 0;
       // @(posedge clk);
	
///	if (final_output !== new_expected_result[rdaddr]) begin
   //          error_count = error_count + 1;
     //        $display("ERROR at time %0t: Mismatch detected at address %0d!", $time, rdaddr);
       //      $display("Expected = %0d", new_expected_result[rdaddr]);
         //    $display("current = %0d", final_output);
        //*/
      //  end
        rdaddr = rdaddr + 1'b1;
	 @(posedge clk);
        RD = 0;
	@(posedge clk);
  //  end 

   /*
    if (final_output !== new_expected_result[rdaddr]) begin
	 error_count = error_count + 1;
        $display("ERROR at time %0t: Mismatch detected at address %0d!", $time, rdaddr);
        $display("Expected = %0d", new_expected_result[rdaddr]);
        $display("current = %0d", final_output);

    end 
    */
    //increment address for the next read
/*    if (rdaddr < (2**ADDRESS_WIDTH)-1) begin
	RD = 0;
        @(posedge clk);
        rdaddr = rdaddr + 1;
        RD = 1;
    end*/
   // if (error_count !== 0 )
//  #2000      $finish;

  end
/*
  initial begin
 #6000      $finish;
  end */

endmodule
