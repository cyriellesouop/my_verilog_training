`timescale 1ns/1ps

module testbench; 
	
      parameter ADDRESS_WIDTH = 4;
      parameter DATA_WIDTH = 12;
      parameter PERIOD = 4;
      localparam VALUE_WIDTH = 4;
      localparam VECTOR_LENGTH= DATA_WIDTH / VALUE_WIDTH;


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

	reg [2*DATA_WIDTH:0] expected_result [2**ADDRESS_WIDTH-1:0];

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
    rdaddr =0;
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
                dataIn2[(j*VALUE_WIDTH) +: VALUE_WIDTH] = val + 2;

		@(posedge clk);
               // expected_result[j] <= dot_product(dataIn1, dataIn2);
                val = val + 1;
            end
	  //  res = dot_product(dataIn1, dataIn2);
	    expected_result[i] = dot_product(dataIn1, dataIn2);
	   // expected_result[i] = dot_product(dataIn1, dataIn2);
	    @(posedge clk);
            $display("\n [%0t]  wraddr %0d:  dataIn1 %b:  dataIn2: %b, expected_result%d:", $time,  wraddr,  dataIn1, dataIn2, expected_result[i]);
            @(posedge clk);
    end
    WR = 0;
    @(posedge clk);
    startProcessing_rd = 1;

    repeat(50)@(posedge clk);

  end

  always @(final_output)
begin
    RD = 1;
    @(posedge clk);
    RD = 0;

    $display("[%0t] Output changed! RD enabled | rdaddr=%0d | DUT=%0d | Expected=%0d",
             $time, rdaddr, final_output, expected_result[rdaddr]);

    if (final_output !== expected_result[rdaddr])
        $display(" MISMATCH at addr %0d!", rdaddr);
    else
        $display("MATCH at addr %0d", rdaddr);

    rdaddr = rdaddr + 1;

    if (rdaddr ==((1 << ADDRESS_WIDTH)-1)) begin
        $display("Simulation completed successfully.");
        #20 $finish;
    end
end


/*
  always @(final_output)begin

    if (rdaddr < 2**ADDRESS_WIDTH) begin
	rdaddr = rdaddr+ 1;
	 @(posedge clk);
   	RD = 1;
        repeat(2) @(posedge clk);
	RD = 0;
	@(posedge clk);

        $display("\n [%0t] rdAddr : %0d    final_output :  %0d  ", $time,  rdaddr, final_output);
        
     #100 $finish;
  end 

  
  */

endmodule

