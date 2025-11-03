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
	wire done_reading;



	//memory writer interface
	wire [2*DATA_WIDTH:0] result_dotProduct;
	wire [2*DATA_WIDTH:0] input_outputMemory;
	
	//output memory interface
	wire done_writing;
	wire [ADDRESS_WIDTH-1:0]  wraddrOut ; 


//	assign rdaddrOut = wraddr;

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

	memoryReader #(
		.ADDRESS_WIDTH(ADDRESS_WIDTH),
                .DATA_WIDTH(DATA_WIDTH)
	)
	memread1 (
	      .clk(clk),
              .rstn(rstn),
	      .startProcessing(startProcessing_rd),
	      .dataOut(dataOut1),
	      
	      .done_reading(done_reading),
	      .rdaddr(rdaddrOut),
	      .inputVector(inputVector1)	
	);

//	assign rdaddrOut = wraddr;


        memoryReader #(
                .ADDRESS_WIDTH(ADDRESS_WIDTH),
                .DATA_WIDTH(DATA_WIDTH)
        )
        memread2 (
              .clk(clk),
              .rstn(rstn),
              .startProcessing(startProcessing_rd),
              .dataOut(dataOut2),

	      .done_reading(done_reading),
              .rdaddr(rdaddrOut),
              .inputVector(inputVector2)
        );

	//assign done_reading = startProcessing_rd;
    	multiplier #(
              .ADDRESS_WIDTH(ADDRESS_WIDTH),
              .DATA_WIDTH(DATA_WIDTH)
    	) 
	multiplier(
             .clk(clk),
             .rstn(rstn),
             .done_reading(done_reading),
             .inputVector1(inputVector1),
             .inputVector2(inputVector2),
             .startProcessing_wr(startProcessing_wr),
             .result_dotProduct(result_dotProduct)
        );

	memoryWriter #(
                .ADDRESS_WIDTH(ADDRESS_WIDTH),
              .DATA_WIDTH(DATA_WIDTH)

        )
        memwrite (
              .clk(clk),
              .rstn(rstn),
              .startProcessing_wr(startProcessing_wr),
              .done_writing(done_writing),
              .result_dotProduct(result_dotProduct),
              .input_outputMemory(input_outputMemory),
	      .wraddr(wraddrOut)
        );
     	
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
        //assign done = done_writing;
        
	
endmodule

