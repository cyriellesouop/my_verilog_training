`timescale 1ns/1ps

module cpu_tb;

  parameter DATA_WIDTH    = 10;
  parameter ADDRESS_WIDTH = 3;
  localparam PERIOD = 4;

  reg clk=0;
  reg rstn;
  reg start;

  reg  [DATA_WIDTH-1:0] inst;
  reg  [DATA_WIDTH-1:0] data_op;
  wire [ADDRESS_WIDTH-1:0] pc;
  wire [ADDRESS_WIDTH-1:0] addr_op;
  wire [ADDRESS_WIDTH-1:0] addr_Res;
  wire [DATA_WIDTH-1:0] data_Res;
  wire read;
  wire write_Res;
  wire start_fetch;

  cpu #(
    .DATA_WIDTH(DATA_WIDTH),
    .ADDRESS_WIDTH(ADDRESS_WIDTH)
  ) DUT (
    .clk(clk),
    .rstn(rstn),
    .start(start),
    .inst(inst),
    .pc(pc),
    .data_op(data_op),
    .addr_op(addr_op),
    .addr_Res(addr_Res),
    .data_Res(data_Res),
    .start_fetch(start_fetch),
    .read(read),
    .write_Res(write_Res)
  );

  
  always #(PERIOD/2) clk = ~clk; 
 
  reg [DATA_WIDTH-1:0] data_mem [0:(1<<ADDRESS_WIDTH)-1];
  reg [DATA_WIDTH-1:0] inst_mem [0:(1<<ADDRESS_WIDTH)-1];

  // read interface
  always @(*) begin
    if (read)
      data_op = data_mem[addr_op];
    else
      data_op = 0;
  end

  initial begin
    rstn = 0;
    start = 0;
    inst = 0;

    // Initialize memories
    #20;
    rstn = 1; 
    repeat(2)@(posedge clk)

    // Initialize memories
    data_mem[0] = 10'd3;
    data_mem[1] = 10'd7;
    data_mem[2] = 10'd15;

    inst_mem[0] = {3'b010, 3'b001, 3'b000, 1'b0}; // addrA=0, addrB=1, addr_res=2, opcode=0
    inst_mem[1] = {3'b011, 3'b000, 3'b000, 1'b1}; // addrA=0, addr_res=3, opcode=1
    //
    repeat(2) @(posedge clk)


    // Start the CPU for instruction 0
    start = 1;
    @(posedge clk);
    inst = inst_mem[0];
    #10;
    start = 0;

    // wait to complete ADD
    repeat(50) @(posedge clk);

    $display(" ADD instruction: data_Res = %d", data_Res);

    // Start the CPU for instruction 1
    start = 1;
    @(posedge clk);
    inst = inst_mem[1];
    #10;
   
    @(posedge clk);
    start = 0;

    // Wait  to complete NOT
    repeat(50) @(posedge clk);

    // Show results
    $display("NOT instruction: data_Res = %d", data_Res);

   #100 $finish;
  end

endmodule

