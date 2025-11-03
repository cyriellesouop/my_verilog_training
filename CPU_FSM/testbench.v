`timescale 1ns/1ps

module testbench;

  parameter DATA_WIDTH = 16;
  localparam  PERIOD = 4;
  reg clk=0;
  reg rstn;

  //slave interface (inputs)
  reg axis1_tvalid;
  wire axis1_tready;
  reg [DATA_WIDTH-1:0] axis1_tdata;

  reg axis2_tvalid;
  wire axis2_tready;
  reg [DATA_WIDTH-1:0] axis2_tdata;

  //master interface (outputs of the system)
  wire axim3_tvalid;
  reg axim3_tready;
  wire [DATA_WIDTH-1:0] axim3_tdata;

  //external opcode
  reg [3:0] opCode;

  
  top #(.DATA_WIDTH(DATA_WIDTH)) 
  
  DUT (
    .clk(clk),
    .rstn(rstn),

    .axis1_tvalid(axis1_tvalid),
    .axis1_tready(axis1_tready),
    .axis1_tdata(axis1_tdata),

    .axis2_tvalid(axis2_tvalid),
    .axis2_tready(axis2_tready),
    .axis2_tdata(axis2_tdata),

    .axim3_tvalid(axim3_tvalid),
    .axim3_tready(axim3_tready),
    .axim3_tdata(axim3_tdata),

    .opCode(opCode)
  );

  
  always #(PERIOD/2) clk = ~clk; 

  
  initial begin
    
    rstn = 0;
    
    #10  rstn = 1;
    @(posedge clk);
    axim3_tready = 0;
    repeat(4)@(posedge clk);

     //send data to cpu1
    axis1_tdata = {6'b000101,6'b000011,4'b0000}; // 5+3 = 8
    axis1_tvalid = 1;

    axis2_tdata = {6'b00001,6'b000010,4'b0000}; // 1+2 =3
    axis2_tvalid = 1;

    opCode = 4'b0001; //opCode = 2, AND
    
    repeat(1)@(posedge clk);
    axim3_tready = 1'b1;

    #1000 $finish;

  end

  initial begin
	$monitor($time, " axim3_tvalid = %b  axim3_tdata = %0d ", axim3_tvalid, axim3_tdata );

  end

 



/*
    for (opCode = 0; opCode <= 3; opCode = opCode + 1) begin
      
      for (axis1_data = 16'h0001; axis1_data < 16'h0006; axis1_data = axis1_data + 1) begin
        //Loop through  axis2_data
	
        for (axis2_data = 16'h001A; axis2_data < 16'h002A; axis2_data = axis2_data + 1) begin
          
          axis1_tvalid = 1;
          axis2_tvalid = 1;

          repeat(2)@(posedge clk);
          axis1_tvalid = 0;
          axis2_tvalid = 0;

          @(posedge clk);
          wait(axim3_tvalid && axim3_tready);
	  @(posedge clk);
          $display("Time %0t : opcode=%0d, axis1_data=%h, axis2_data=%h,  Output_axim3_data=%h", $time, opCode, axis1_data, axis2_data, axim3_data);

          @(posedge clk); 
        end
      end
    end
    $finish;
  end
*/
endmodule



