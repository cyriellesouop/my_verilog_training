`timescale 1ns/1ps

module tb_writer;

    parameter ADDRESS_WIDTH = 3;
    parameter DATA_WIDTH    = 12;
    parameter PERIOD        = 4;

    reg clk = 0;
    reg rstn;
    reg startProcessing_wr;
    reg [2*DATA_WIDTH:0] result_dotProduct;

    wire [2*DATA_WIDTH:0] input_outputMemory;
    wire [ADDRESS_WIDTH-1:0] wraddr;
    wire done_writing;

    reg [(2**ADDRESS_WIDTH)-1:0] i;


    // MemoryWriter to write into the memory
    memoryWriter #(
        .ADDRESS_WIDTH(ADDRESS_WIDTH),
        .DATA_WIDTH(DATA_WIDTH)
    ) DUT (
        .startProcessing_wr(startProcessing_wr),
        .clk(clk),
        .rstn(rstn),
        .result_dotProduct(result_dotProduct),
        .input_outputMemory(input_outputMemory),
        .wraddr(wraddr),
        .done_writing(done_writing)
    );

    
    always #(PERIOD/2) clk = ~clk;

    
    initial begin
        rstn = 0;
        startProcessing_wr = 0;
        result_dotProduct = 0;

        repeat(2) @(posedge clk);

        rstn = 1;   
        @(posedge clk);

        // Write a sequence of values
        for (i = 0; i < (2**ADDRESS_WIDTH); i = i + 1) begin
            result_dotProduct  = i + 10;
	    @(posedge clk);
            startProcessing_wr = 1;
            @(posedge clk);
	    startProcessing_wr = 0;
        end
      #100 $finish;
   end

    // monitor
    initial begin
        $monitor("[%0t] wraddr=%0d result=%0d input_outputMemory=%0d done=%b",
                 $time, wraddr, result_dotProduct, input_outputMemory, done_writing);
    end

endmodule

