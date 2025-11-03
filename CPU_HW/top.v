`timescale 1ns/1ps

module top 
	#(
	    parameter ADDRESS_WIDTH = 3,
	    parameter DATA_WIDTH = 10
	)
	(
	  input clk,
 	  input rstn,

	  //write interface for the instruction memory
          input WR_instmem,
          input [ADDRESS_WIDTH-1:0] wraddr_instmem,
          input [(DATA_WIDTH-1):0]  dataIn_instmem,
	  input start,

	  //write interface for the data memory 
	  input WR_datamem,
          input [ADDRESS_WIDTH-1:0] wraddr_datamem,
          input [(DATA_WIDTH-1):0]  dataIn_datamem,
       
	  //read interface for the data memory
	  input RD_datamem,
          input [ADDRESS_WIDTH-1:0] rdaddr_datamem,
          output wire [DATA_WIDTH-1:0] result_datamem
    
        /*
          input WR_datamemA,
          input [ADDRESS_WIDTH-1:0] wraddr_datamemA,
          input [(DATA_WIDTH-1):0]  dataIn_datamemA,

	  // read interface from the data memory containing the result
	  input RD,
	  input [ADDRESS_WIDTH-1:0] rdaddr,
	  output wire [DATA_WIDTH-1:0] result
	*/
	);
	 

	 //instruction memory instance
	 memory #(
                .ADDRESS_WIDTH(ADDRESS_WIDTH),
                .DATA_WIDTH(DATA_WIDTH)
        )
         instrmem (
                .clk(clk),
                .rstn(rstn),
                .WR(WR_instmem),
                .wraddr(wraddr_instmem),
                .dataIn(dataIn_instmem),

                .RD(start_fetch),
                .rdaddr(pc),
                .dataOut(inst)
        );

	//cpu instance

	cpu #(
                .ADDRESS_WIDTH(ADDRESS_WIDTH),
                .DATA_WIDTH(DATA_WIDTH)
        )
	 cpuinst(
	 
	 .clk(clk),
         .rstn(rstn),
         .start(start),

	 // instruction interface
	 .inst(inst),
	 .pc(pc),

	// data interface
	 .data_op(data_op),
	// .data_opB(data_opB),
	 .addr_op(addr_op),
	// .addr_opB(addr_opB),
	 .addr_Res(addr_Res),
	 .data_Res(data_Res),

	 //control signals
	 .start_fetch(start_fetch),
	 .read(read),
	 .write_Res(write_Res),
	 
	 );

	 // data memory instance

	memory #(
		.ADDRESS_WIDTH(ADDRESS_WIDTH),
		.DATA_WIDTH(DATA_WIDTH)
	)
	datamem (
		.clk(clk),
		.rstn(rstn),

		.WR(write_Res),
		.wraddr(addr_Res),
		.dataIn(data_Res),
		
		.RD(read),
      		.rdaddr(addr_op),
		.dataOut(data_op)
	);
	
	/*	
	memory #(
		.ADDRESS_WIDTH(ADDRESS_WIDTH),
		.DATA_WIDTH(DATA_WIDTH)
	)
	datamemB (
		.clk(clk),
		.rstn(rstn),
		.WR(WR_datamemB),
		.wraddr(wraddr_datamemB),
		.dataIn(dataIn_datamemB),
		
		.done_reading(done_reading_datamemB),
		.RD(RD_datamem),
      		.rdaddr(rdaddr_datamemB),
		.dataOut(dataOut_datamemB)
	);

	memory #(
                .ADDRESS_WIDTH(ADDRESS_WIDTH),
                 .DATA_WIDTH(DATA_WIDTH)
        )
        datamem2 (
                .clk(clk),
                .rstn(rstn),
                .WR(WR_datamem2),
                .wraddr(wraddr_datamem2),
                .dataIn(dataIn_datamem2),
               // .done_reading(done_reading_datamem2),
                .RD(RD),
                .rdaddr(rdaddr),
                .dataOut(result)
        );

*/

endmodule
