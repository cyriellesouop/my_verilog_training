`timescale 1ns/1ps

module top 
	#(
	    parameter ADDRESS_WIDTH = 4,
	    parameter DATA_WIDTH = 12
	)
	(
	  input clk,
 	  input rstn,
          input WR,
          input [ADDRESS_WIDTH-1:0] wraddr,
          input [(DATA_WIDTH-1):0]  dataIn1,
          input [(DATA_WIDTH-1):0]  dataIn2,
	  input startProcessing_rd,

	  input RD,
	  input [ADDRESS_WIDTH-1:0] rdaddr,
	 // output done,
	  output wire [2*DATA_WIDTH:0] final_output
	);

	

	//memory interfaces
	wire [DATA_WIDTH-1:0] dataOut1;
	wire [DATA_WIDTH-1:0] dataOut2;
	
	

	//memory reader interface
	wire [DATA_WIDTH-1:0]  inputVector1;
	wire [DATA_WIDTH-1:0] inputVector2;
	wire startProcessing_wr;
	wire startProcessing_wr2;
	wire [ADDRESS_WIDTH-1:0] rdaddrOut;
	wire done_reading, done_reading1, done_reading2;



	//memory writer interface
	wire [2*DATA_WIDTH:0] result_dotProduct;
	wire [2*DATA_WIDTH:0] input_outputMemory;
	
	//output memory interface
	wire done_writing;
	wire [ADDRESS_WIDTH-1:0]  wraddrOut ;

        wire full_fifo1,full_fifo2, full_fifo3;
        wire empty_fifo1 , empty_fifo2, empty_fifo3; 
        wire  RD_fifo1, RD_fifo2 , RD_fifo3 ;
        wire [DATA_WIDTH-1:0]  dataOut_fifo1, dataOut_fifo2;
        wire [2*DATA_WIDTH:0]	dataOut_fifo3 ;
	

	assign RD_fifo1 = ~empty_fifo1;
	assign RD_fifo2 = ~empty_fifo2;
	assign RD_fifo3 = ~empty_fifo3;
	assign done_reading = (~empty_fifo1) && (~empty_fifo2);

	


        // input memory 1
	memory #(
		.ADDRESS_WIDTH(ADDRESS_WIDTH), 
		.DATA_WIDTH(DATA_WIDTH)       
	) 
	mem1 ( 
		.clk(clk),
		.rstn(rstn),
		.WR(WR),
		.wraddr(wraddr),
		.dataIn(dataIn1),

		.RD(startProcessing_rd),
      		.rdaddr(rdaddrOut),
		.dataOut(dataOut1)	
	);


	//input memory2
	memory #(
                .ADDRESS_WIDTH(ADDRESS_WIDTH),
                 .DATA_WIDTH(DATA_WIDTH)
        )
        mem2 (
                .clk(clk),
                .rstn(rstn),
                .WR(WR),
                .wraddr(wraddr),
                .dataIn(dataIn2),

                .RD(startProcessing_rd),
                .rdaddr(rdaddrOut),
                .dataOut(dataOut2)
        );

	//memory reader 1
	memoryReader #(
		.ADDRESS_WIDTH(ADDRESS_WIDTH),
                .DATA_WIDTH(DATA_WIDTH)
	)
	memread1 (
	      .clk(clk),
              .rstn(rstn),
	      .startProcessing(startProcessing_rd),
	      .dataOut(dataOut1),
	      
	      .done_reading(done_reading1),
	      .rdaddr(rdaddrOut),
	      .inputVector(inputVector1)	
	);

       //memory reader 2
        memoryReader #(
                .ADDRESS_WIDTH(ADDRESS_WIDTH),
                .DATA_WIDTH(DATA_WIDTH)
        )
        memread2 (
              .clk(clk),
              .rstn(rstn),
              .startProcessing(startProcessing_rd),
              .dataOut(dataOut2),

	      .done_reading(done_reading2),
              .rdaddr(rdaddrOut),
              .inputVector(inputVector2)
      );
	
    
    //  assign RD_fifo = ~empty;

      fifo #( 
      	.DATAWIDTH ( DATA_WIDTH ),
	.DEPTH (2**ADDRESS_WIDTH),
	.PTR_WIDTH (ADDRESS_WIDTH)
      )
      fifo1(
       .clk(clk),
       .rstn(rstn),

       .WR(done_reading1),
       .dataIn (inputVector1),
       .full(full_fifo1),
       
       .RD(RD_fifo1),
       .empty(empty_fifo1),
       .dataOut(dataOut_fifo1)
      );

      // fifo 2

      fifo #(
        .DATAWIDTH ( DATA_WIDTH ),
        .DEPTH (2**ADDRESS_WIDTH),
        .PTR_WIDTH (ADDRESS_WIDTH)
      )
      fifo2(
       .clk(clk),
       .rstn(rstn),

       .WR(done_reading2),
       .dataIn (inputVector2),
       .full(full_fifo2),

       .RD(RD_fifo2),
       .empty(empty_fifo2),
       .dataOut(dataOut_fifo2)
      );

     // assign done_reading = (~empty_fifo1) && (~empty_fifo2); 


	//DotProduct calculator
    	multiplier #(
              .ADDRESS_WIDTH(ADDRESS_WIDTH),
              .DATA_WIDTH(DATA_WIDTH)
    	) 
	multiplier(
             .clk(clk),
             .rstn(rstn),
             .done_reading(done_reading),
             .inputVector1(dataOut_fifo1),
             .inputVector2(dataOut_fifo2),
             .startProcessing_wr(startProcessing_wr),
             .result_dotProduct(result_dotProduct)
        );


	//fifo3
 
     fifo #(
        .DATAWIDTH ( 2*DATA_WIDTH+1 ),
        .DEPTH (2**ADDRESS_WIDTH),
        .PTR_WIDTH (ADDRESS_WIDTH)
      )
      fifo3(
       .clk(clk),
       .rstn(rstn),

       .WR(startProcessing_wr),
       .dataIn (result_dotProduct),
       .full(full_fifo3),

       .RD(RD_fifo3),
       .empty(empty_fifo3),
       .dataOut(dataOut_fifo3)
      );


	//memory writer
	memoryWriter #(
              .ADDRESS_WIDTH(ADDRESS_WIDTH),
              .DATA_WIDTH(DATA_WIDTH)

        )
        memwrite (
              .clk(clk),
              .rstn(rstn),

              .startProcessing_wr(~empty_fifo3),
	      .result_dotProduct(dataOut_fifo3),

              .done_writing(done_writing),
              .input_outputMemory(input_outputMemory),
	      .wraddr(wraddrOut)
        );
     	
	//outputmemory
	 memory #(
                .ADDRESS_WIDTH(ADDRESS_WIDTH),
                 .DATA_WIDTH(2*DATA_WIDTH+1)
        )

        outputmem (
                .clk(clk),
                .rstn(rstn),
                .WR(done_writing),
                .wraddr(wraddrOut),
                .dataIn(input_outputMemory),

                .RD(RD),
                .rdaddr(rdaddr),
                .dataOut(final_output)
        );
        
        
	
endmodule

