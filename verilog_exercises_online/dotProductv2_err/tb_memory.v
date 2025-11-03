`timescale 1ns/1ps

module tb_memory;

    parameter ADDRESS_WIDTH = 3;
    parameter DATA_WIDTH    = 12;
    parameter PERIOD = 4;

    reg clk=0;
    reg rstn ;
    reg RD;
    reg  WR;
    reg [ADDRESS_WIDTH-1:0] wraddr;
    reg [ADDRESS_WIDTH-1:0] rdaddr;
    reg [DATA_WIDTH-1:0]    dataIn;
    wire [DATA_WIDTH-1:0]   dataOut;

    reg [(2**ADDRESS_WIDTH):0] i,j;

    memory #(
        .ADDRESS_WIDTH(ADDRESS_WIDTH),
        .DATA_WIDTH(DATA_WIDTH)
    ) DUT (
        .RD(RD),
        .WR(WR),
        .clk(clk),
        .wraddr(wraddr),
        .rdaddr(rdaddr),
        .dataIn(dataIn),
        .dataOut(dataOut)
    );

    
    always #(PERIOD/2) clk = ~clk;

    // writing interface
    initial begin
	rstn = 0;
	@(posedge clk);
	rstn = 1;
        repeat (1) @(posedge clk);
        WR = 1;

        for (i = 0; i < (2**ADDRESS_WIDTH); i = i + 1) begin
            @(posedge clk);
            wraddr = i[ADDRESS_WIDTH-1:0 ];
            dataIn = i + 10;
        end
	@(posedge clk);
        WR = 0;
    end

    // reading interface
    initial begin
	RD = 0;
	wait(WR==0 );
	@(posedge clk);
       // RD = 0;
       // RD = 1;

        for (j = 0; j < (2**ADDRESS_WIDTH); j = j + 1) begin
         	RD = 1;
	     	@(posedge clk);
           rdaddr = j[ADDRESS_WIDTH-1:0];
        end
        @(posedge clk);
        RD = 0;
        #100 $finish;
    end

    // Monitor activity
    initial begin
        $monitor ("\n [%0t] RD=%b j = %0d  rdaddr=%0d dataOut=%0d ", $time, RD, j, rdaddr, dataOut);

	$monitor ("\n [%0t] WR=%b i= %0d  wraddr=%0d dataIn=%0d", $time, WR, i, wraddr, dataIn);
        //$monitor("\n Time=%0t | WR=%b wraddr=%0d dataIn=%0d | RD=%b rdaddr=%0d dataOut=%0d",$time, WR, wraddr, dataIn, RD, rdaddr, dataOut);
    end

endmodule

