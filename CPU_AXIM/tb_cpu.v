`timescale 1ns/1ps

module tb_cpu;
parameter PERIOD = 4; 
parameter ADDRESS_WIDTH = 32;
parameter DATA_WIDTH = 8;


reg clk=0;
reg rstn;

//write address channel
reg [ADDRESS_WIDTH-1:0] awaddr;
reg awvalid;
wire awready;

//write data channel
reg [DATA_WIDTH-1:0] wdata;
reg wvalid;
wire wready;

 //write response channel
wire [1:0] bresp;
wire bvalid;
reg bready;

//read address channel
reg [ADDRESS_WIDTH-1:0] araddr;
reg arvalid;
wire arready;

//read data channel
wire [DATA_WIDTH-1:0] rdata;
wire rvalid;
wire [1:0] rresp;
reg  rready;

  cpu  #(
  	.ADDRESS_WIDTH(ADDRESS_WIDTH ),
	.DATA_WIDTH (DATA_WIDTH  )
  )
  DUT(
  	.clk(clk),
	.rstn(rstn),

	//write address channel
	.awaddr(awaddr ),
	.awvalid(awvalid ),
	.awready(awready ),

	//write data channel
	.wdata(wdata ),
        .wvalid(wvalid ),
	.wready(wready ),

	//write response channel
	.bresp(bresp ),
	.bvalid(bvalid ),
	.bready(bready),

	//read address channel
	.araddr(araddr ),
	.arvalid(arvalid ),
	.arready(arready ),

	//read data channel
	.rdata(rdata ),
	.rvalid(rvalid ),
	.rresp(rresp ),
	.rready(rready)
  );

  always #(PERIOD/2) clk = ~clk;

  initial begin
   rstn = 0;
   repeat(2)@(posedge clk);
   rstn= 1;

repeat(2)@(posedge clk);
   //TRANSACTION 1 (write op1 to address 0)

   //write Address
   awaddr = {ADDRESS_WIDTH{1'b0}}; 
   awvalid = 1'b1;
   wait (awready == 1'b1 );
   $display("%0t ADDR_OP1 = 32'b%b",$time, awaddr);
   @(posedge clk);
   awvalid = 1'b0;
   @(posedge clk);

   //write data
   wdata = 8'b100;
   wvalid = 1'b1;

   wait (wready == 1'b1);
   $display("%0t  OP1 = 8'b%b", $time, wdata);
   @(posedge clk);
   wvalid = 1'b0;

   //write Response
   wait(bvalid == 1'b1);
   @(posedge clk);
   bready = 1'b1;
   @(posedge clk);
   if(bresp > 2'b00 )
	   $display("%0t PROBLEM WITH THE WRITE TRANSACTION bresp = 2'b%b ", $time,  bresp);
   bready = 1'b0;
   @(posedge clk);
 
   //TRANSACTION 2 (write op2 to address 1)

   //write Address
   @(posedge clk);
   wait (awready == 1'b1 );
   awaddr = 32'b1;
   awvalid = 1'b1;
   $display("%0t ADDR_OP2 = 32'b%b",$time, awaddr);
   @(posedge clk);
   awvalid = 1'b0;

   //write data
   wait (wready == 1'b1);
   wdata = 8'b11;
   wvalid = 1'b1;
   @(posedge clk);
    $display("%0t  OP2 = 8'b%b", $time, wdata);
   @(posedge clk);
   wvalid = 1'b0;

   //write Response
   wait(bvalid == 1'b1);
   bready = 1'b1;
   @(posedge clk);
   if(bresp > 2'b00 )
           $display("%0t PROBLEM WITH THE WRITE TRANSACTION bresp = 2'b%b ", $time,  bresp);
   bready = 1'b0;
   @(posedge clk);

   //TRANSACTION 3 (write opcode to address 2)

   //write Address
   awaddr = 32'b10;
   awvalid = 1'b1;
   wait (awready == 1'b1 );
   $display("%0t ADDR_OPCODE = 32'b%b",$time, awaddr);
   @(posedge clk);
   awvalid = 1'b0;

   //write data
   wdata = 8'b0;
   wvalid = 1'b1;
   wait (wready == 1'b1);
   $display("%0t  OPCODE = 8'b%b", $time, wdata);
   @(posedge clk);
   wvalid = 1'b0;

   //write Response
   wait(bvalid == 1'b1);
   bready = 1'b1;
   @(posedge clk);
   if(bresp > 2'b00 )
           $display("%0t PROBLEM WITH THE WRITE TRANSACTION bresp = 2'b%b ", $time,  bresp);
   bready = 1'b0;
   @(posedge clk);

   //TRANSACTION 4 (Read result from address 3)
   //Read Address
   araddr = 32'b11;
   arvalid = 1'b1;
   wait (arready == 1'b1);
   $display("%0t READ_ADDR = 32'b%b",$time, araddr);
   @(posedge clk);
   arvalid = 1'b0;

   //Read Data
   rready = 1'b1;
   wait(rvalid == 1'b1);
   $display("%0t  RDATA = 8'b%b RRESP =2'b%b ", $time, rdata, rresp);
   @(posedge clk);
   rready = 1'b0;

   #100 $finish;
  end

  endmodule
