`timescale 1ns/1ps

module testbench; 
	
    parameter ADDRESS_WIDTH = 3;
    parameter DATA_WIDTH = 10;
    localparam PERIOD = 4;
    

    reg clk=0;
    reg rstn;
    reg WR_instmem;
    reg [ADDRESS_WIDTH-1:0] wraddr_instmem;
    reg [DATA_WIDTH-1:0] dataIn_instmem;
    reg start;

    reg WR_datamemA;
    reg [ADDRESS_WIDTH-1:0] wraddr_datamemA;
    reg [DATA_WIDTH-1:0] dataIn_datamemA;
    
     reg WR_datamemB;
    reg [ADDRESS_WIDTH-1:0] wraddr_datamemB;
    reg [DATA_WIDTH-1:0] dataIn_datamemB;

    reg RD;
    reg [ADDRESS_WIDTH-1:0] rdaddr;
    wire [DATA_WIDTH-1:0] result;

    // Instantiate top module
    top #(
        .ADDRESS_WIDTH(ADDRESS_WIDTH),
        .DATA_WIDTH(DATA_WIDTH)
    ) DUT (
        .clk(clk),
        .rstn(rstn),

        // instr mem
        .WR_instmem(WR_instmem),
        .wraddr_instmem(wraddr_instmem),
        .dataIn_instmem(dataIn_instmem),
        .start(start),

        // data memA
        .WR_datamemA(WR_datamemA),
        .wraddr_datamemA(wraddr_datamemA),
        .dataIn_datamemA(dataIn_datamemA),
        
        // data memB
        .WR_datamemB(WR_datamemB),
        .wraddr_datamemB(wraddr_datamemB),
        .dataIn_datamemB(dataIn_datamemB),

        // result mem2
        .RD(RD),
        .rdaddr(rdaddr),
        .result(result)
    );

    always #(PERIOD/2) clk = ~clk;

    initial begin
        // Initialize inputs
        rstn = 0;
        WR_instmem = 0;
        WR_datamemA = 0;
        WR_datamemB = 0;
        RD = 0;
        start = 0;
        wraddr_instmem = 0;
        wraddr_datamemA = 0;
        wraddr_datamemB = 0;
//        dataIn_instmem = 0;
        dataIn_datamemA = 0;
        dataIn_datamemB = 0;
        rdaddr = 0;

        repeat(2)@(posedge clk);
        rstn = 1;
	@(posedge clk);

        // ----------------------------------
        // Load operands into datamem1
        //------------------------------------
	
	//5 at address 0
        WR_datamemA = 1;
        wraddr_datamemA = 3'd0;
        dataIn_datamemA = 10'd5;
        @(posedge clk);
        WR_datamemA = 0;

       // 7 at address 1
        @(posedge clk);
        WR_datamemB = 1;
        wraddr_datamemB = 3'd1;
        dataIn_datamemB = 10'd7;
        @(posedge clk);
        WR_datamemB = 0;

	// ----------------------------------
        // Load instructions into instrmem
	// -----------------------------------
	
        //  ADD opA, opB, Res
        @(posedge clk);
        WR_instmem = 1;
        wraddr_instmem = 3'd0;
        dataIn_instmem = 10'b0100010000; // result store in addr 2
        @(posedge clk);
        WR_instmem = 0;

        // ----------------------------------
        //  Start CPU
	//  --------------------------------
	
        @(posedge clk);
        start = 1;
        repeat(10)@(posedge clk);
       // start = 0;

        // ---------------------------------
        //  Read result from datamem2
	//  --------------------------------
        
        RD = 1;
        rdaddr = 3'd2;  // Assume result stored at address 2
        repeat(2)@(posedge clk);
        RD = 0;
	@(posedge clk);

        $display("Result read from datamem2 = %d", result);
        
	#10000 $finish;
    end
      
endmodule
