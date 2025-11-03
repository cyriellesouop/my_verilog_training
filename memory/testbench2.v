`timescale 1ns/1ps

module testbench2;

    reg clk = 0;
    reg [7:0] addrIn;
    reg [7:0] addrOut;
    reg [1:0] RD;
    reg [1:0] WR;
    reg [31:0] dataIn;
    wire [31:0] dataOut;

    // Clock generation: Toggle every 2ns
    always #2 clk = ~clk;

    // Instantiate the memory module
    memory DUT(RD, WR, clk, addrIn, addrOut, dataIn, dataOut);

    initial begin
        // Initial values
        RD = 2'b00;
        WR = 2'b00;
        addrIn = 8'hDA;
        addrOut = 8'h00;
        dataIn = 32'hAAAA;

        // Wait a bit before writing
        #1;
        WR = 2'b01;    // Enable write
        #4;            // Wait for rising edge of clk
        WR = 2'b00;    // Disable write

        // Display after write
        $display ("[%0t] WRITE DONE: addrIn=0x%0h, dataIn=0x%0h", $time, addrIn, dataIn);

        // Set up for read
        #2;
        addrOut = 8'hDA;
        RD = 2'b01;    // Enable read
        #4;            // Wait for rising clk edge
        RD = 2'b00;    // Disable read

        // Display read result
        $display ("[%0t] READ DONE: addrOut=0x%0h, dataOut=0x%0h", $time, addrOut, dataOut);

        #10;
        $finish;
    end

endmodule

