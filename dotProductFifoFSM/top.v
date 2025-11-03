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
	  output wire [2*DATA_WIDTH:0] final_output,
	  output fsm_ready
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


	wire WR_mem1_wire;
	 wire WR_mem2_wire;
        wire [ADDRESS_WIDTH-1:0]  wraddr_mem1_wire,wraddr_mem2_wire   ;
	wire [DATA_WIDTH-1:0 ] dataIn_mem1_write  ;
	wire fsm1_ready;


	wire [DATA_WIDTH-1:0 ] dataIn_mem2_write;
        wire fsm2_ready;

	// to specify that the fsm is ready
	assign fsm_ready = fsm1_ready && fsm2_ready;
	//fsm memory 1
	
	fsm #( .ADDRESS_WIDTH(ADDRESS_WIDTH), .DATA_WIDTH(DATA_WIDTH)
	)
	fsm1(
	  .clk(clk),
   	  .rstn(rstn),

	  .memIn_wraddr(wraddr),
          .memIn_WR(WR),
	  .memIn_data(dataIn1),

	  .memOut_wraddr(wraddr_mem1_wire),
	  .memOut_WR( WR_mem1_wire ),
	  .memOut_data(dataIn_mem1_write ),
	  .ready(fsm1_ready )
	);

  

        
        // input memory 1
	memory #(
		.ADDRESS_WIDTH(ADDRESS_WIDTH), 
		.DATA_WIDTH(DATA_WIDTH)       
	) 
	mem1 ( 
		.clk(clk),
		.rstn(rstn),
		.WR( WR_mem_wire ),
		.wraddr(wraddr_mem_wire),
		.dataIn(dataIn1_mem_write),

		.RD(startProcessing_rd),
      		.rdaddr(rdaddrOut),
		.dataOut(dataOut1)	
	);


	//fsm memory 2
	//
	    fsm #( .ADDRESS_WIDTH(ADDRESS_WIDTH), .DATA_WIDTH(DATA_WIDTH)
        )
        fsm2(
          .clk(clk),
          .rstn(rstn),

          .memIn_wraddr(wraddr),
          .memIn_WR(WR),
          .memIn_data(dataIn2),

          .memOut_wraddr(wraddr_mem2_wire),
          .memOut_WR( WR_mem2_wire),
          .memOut_data(dataIn_mem2_write ),
          .ready(fsm2_ready)
        );

	//input memory2
	memory #(
                .ADDRESS_WIDTH(ADDRESS_WIDTH),
                 .DATA_WIDTH(DATA_WIDTH)
        )
        mem2 (
                .clk(clk),
                .rstn(rstn),
                .WR( WR_mem_wire),
                .wraddr(wraddr_mem_wire),
                .dataIn(dataIn2_mem_write),

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

