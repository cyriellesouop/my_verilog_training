`timescale 1ns/1ps

module testbench;

  parameter ADDRESS_WIDTH = 2;
  parameter VALUE_WIDTH = 4;
  parameter VECTOR_LENGTH = 4; 
  parameter VECTOR_LENGTH_SM = 2;
  parameter PERIOD = 4;

  reg clk=0;
  reg rstn;
  reg WR;
  reg [ADDRESS_WIDTH-1:0] wraddr;
  reg [((VALUE_WIDTH*VECTOR_LENGTH)-1):0]  dataIn1;
  reg [((VALUE_WIDTH*VECTOR_LENGTH)-1):0]  dataIn2;
  reg startProcessing_rd;

  reg RD;
  reg [ADDRESS_WIDTH-1:0] rdaddr;
  wire [($clog2(VECTOR_LENGTH * ((2** VALUE_WIDTH) - 1) + 1))-1:0] final_output;

  reg [(2**ADDRESS_WIDTH)-1:0 ] i;
  reg [VECTOR_LENGTH-1 : 0] j;
  reg [(2**VALUE_WIDTH)-1:0]val;
  //reg [$clog2(1 + (VECTOR_LENGTH * (2**ADDRESS_WIDTH)))-1 : 0] val;

  // memory signals
  wire [((VALUE_WIDTH*VECTOR_LENGTH)-1):0] dataOut1;
  wire [((VALUE_WIDTH*VECTOR_LENGTH)-1):0] dataOut2;
  

  top 
  #(
      .ADDRESS_WIDTH(ADDRESS_WIDTH),
      .VALUE_WIDTH(VALUE_WIDTH),
      .VECTOR_LENGTH(VECTOR_LENGTH),
      .VECTOR_LENGTH_SM(VECTOR_LENGTH_SM)
  )
  DUT (
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


  memory #(
        .ADDRESS_WIDTH(ADDRESS_WIDTH),
        .VALUE_WIDTH(VALUE_WIDTH),
        .VECTOR_LENGTH(VECTOR_LENGTH)
   )  
    mem1 ( 
        .clk(clk),
        .rstn(rstn),
        .WR(WR),
        .wraddr(wraddr),
        .dataIn(dataIn1),

        .RD(startProcessing_rd),
        .rdaddr(rdaddr),
        .dataOut(dataOut1)    
    );

    memory #(
        .ADDRESS_WIDTH(ADDRESS_WIDTH),
        .VALUE_WIDTH(VALUE_WIDTH),
        .VECTOR_LENGTH(VECTOR_LENGTH)
   )
        
    mem2 (
        .clk(clk),
        .rstn(rstn),
        .WR(WR),
        .wraddr(wraddr),
        .dataIn(dataIn2),

        .RD(startProcessing_rd),
        .rdaddr(rdaddr),
        .dataOut(dataOut2)
      );

  always #(PERIOD/2) clk = ~clk; 

  initial begin
    
    rstn = 0;
    WR = 0;
    val = 0;

    @(posedge clk);
    rstn = 1;

    for (i = 0; i < (2**ADDRESS_WIDTH); i = i + 1) begin
  	 //  WR =1 ;
//	   @(posedge clk);
	    wraddr = i;
	    WR = 1;
           

            // Fill dataIn1 and dataIn2 with incremental values
            for (j = 0; j < VECTOR_LENGTH; j = j + 1) begin
                dataIn1[(j*VALUE_WIDTH) +: VALUE_WIDTH] = val;
                dataIn2[(j*VALUE_WIDTH) +: VALUE_WIDTH] = val + 2;
                val = val + 1;
            end

            @(posedge clk);
    end
    WR = 0;
   // repeat(10) @(posedge clk);
   // $finish;
  end

  initial begin
    #100000;
  //  wait (WR == 0);

    $display("----- Memory Readback -----");
    for (i = 0; i < (2**ADDRESS_WIDTH); i = i + 1) begin
        rdaddr = i;
        startProcessing_rd = 1;
        @(posedge clk);
        $display("Addr %0d: mem1 = %0d | mem2 = %0d", i, dataOut1, dataOut2);
    end
    startProcessing_rd = 0;

    #20 $finish;
end



  // Display
//  initial begin
  //  $monitor("[%0t] rstn=%0b done_reading=%0b vec1=%h vec2=%h result=%0d",
    //         $time, rstn, done_reading, inputVector1, inputVector2, result_dotProduct);
 // end

endmodule

