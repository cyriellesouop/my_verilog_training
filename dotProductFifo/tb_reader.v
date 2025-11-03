`timescale 1ns/1ps

module tb_reader;

    parameter ADDRESS_WIDTH = 3;
    parameter DATA_WIDTH    = 12;
    parameter PERIOD = 4;

    reg clk=0;
    wire [ADDRESS_WIDTH-1:0] rdaddr; 
    reg [DATA_WIDTH-1:0]   dataOut;
    reg rstn;
    reg startProcessing;
    wire [DATA_WIDTH-1:0] inputVector;
    wire done_reading;
    reg [(2**ADDRESS_WIDTH):0] i,j;

    // DUT module
    memoryReader #(
        .ADDRESS_WIDTH(ADDRESS_WIDTH),
        .DATA_WIDTH(DATA_WIDTH)
    ) DUT (
        .clk(clk),
        .rstn(rstn),
        .startProcessing(startProcessing),
        .dataOut(dataOut),
        .rdaddr(rdaddr),
        .inputVector(inputVector)
    );
    
    always #(PERIOD/2) clk = ~clk;
    // read via  memoryReader
    initial begin
	rstn = 0;
	startProcessing = 0;
	dataOut  = 0;
       repeat(2)@(posedge clk);

	rstn = 1;
	@(posedge clk);

        for (j = 0; j < (2**ADDRESS_WIDTH); j = j + 1) begin
	   dataOut = dataOut + 1;
	   @(posedge clk);
	   startProcessing = 1;
	   @(posedge clk);
	  startProcessing = 0;

	end
        #100 $finish;
    end

    initial begin
	$monitor ("\n [%0t] j = %0d startProcessing = %b  dataOut=%0d rdaddr= %b  inputVector=%0d done_reading = %0d", $time, j, startProcessing, dataOut, rdaddr,  inputVector,  done_reading );
    end
endmodule

