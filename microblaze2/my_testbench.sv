`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/20/2023 01:54:57 PM
// Design Name: 
// Module Name: my_testbench
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module UART_RX
  #(parameter CLKS_PER_BIT = 217)
  (
   input        i_Clock,
   input        i_RX_Serial,
   output       o_RX_DV,
   output [7:0] o_RX_Byte
   );
   
  parameter IDLE         = 3'b000;
  parameter RX_START_BIT = 3'b001;
  parameter RX_DATA_BITS = 3'b010;
  parameter RX_STOP_BIT  = 3'b011;
  parameter CLEANUP      = 3'b100;
  
  reg [10:0]     r_Clock_Count = 0;
  reg [2:0]     r_Bit_Index   = 0; //8 bits total
  reg [7:0]     r_RX_Byte     = 0;
  reg           r_RX_DV       = 0;
  reg [2:0]     r_SM_Main     = 0;
  
  
  // Purpose: Control RX state machine
  always @(posedge i_Clock)
  begin
      
    case (r_SM_Main)
      IDLE :
        begin
          r_RX_DV       <= 1'b0;
          r_Clock_Count <= 0;
          r_Bit_Index   <= 0;
          
          if (i_RX_Serial == 1'b0)          // Start bit detected
            r_SM_Main <= RX_START_BIT;
          else
            r_SM_Main <= IDLE;
        end
      
      // Check middle of start bit to make sure it's still low
      RX_START_BIT :
        begin
          if (r_Clock_Count == (CLKS_PER_BIT-1)/2)
          begin
            if (i_RX_Serial == 1'b0)
            begin
              r_Clock_Count <= 0;  // reset counter, found the middle
              r_SM_Main     <= RX_DATA_BITS;
            end
            else
              r_SM_Main <= IDLE;
          end
          else
          begin
            r_Clock_Count <= r_Clock_Count + 1;
            r_SM_Main     <= RX_START_BIT;
          end
        end // case: RX_START_BIT
      
      
      // Wait CLKS_PER_BIT-1 clock cycles to sample serial data
      RX_DATA_BITS :
        begin
          if (r_Clock_Count < CLKS_PER_BIT-1)
          begin
            r_Clock_Count <= r_Clock_Count + 1;
            r_SM_Main     <= RX_DATA_BITS;
          end
          else
          begin
            r_Clock_Count          <= 0;
            r_RX_Byte[r_Bit_Index] <= i_RX_Serial;
            
            // Check if we have received all bits
            if (r_Bit_Index < 7)
            begin
              r_Bit_Index <= r_Bit_Index + 1;
              r_SM_Main   <= RX_DATA_BITS;
            end
            else
            begin
              r_Bit_Index <= 0;
              r_SM_Main   <= RX_STOP_BIT;
            end
          end
        end // case: RX_DATA_BITS
      
      
      // Receive Stop bit.  Stop bit = 1
      RX_STOP_BIT :
        begin
          // Wait CLKS_PER_BIT-1 clock cycles for Stop bit to finish
          if (r_Clock_Count < CLKS_PER_BIT-1)
          begin
            r_Clock_Count <= r_Clock_Count + 1;
     	    r_SM_Main     <= RX_STOP_BIT;
          end
          else
          begin
       	    r_RX_DV       <= 1'b1;
            r_Clock_Count <= 0;
            r_SM_Main     <= CLEANUP;
          end
        end // case: RX_STOP_BIT
      
      
      // Stay here 1 clock
      CLEANUP :
        begin
          r_SM_Main <= IDLE;
          r_RX_DV   <= 1'b0;
        end
      
      
      default :
        r_SM_Main <= IDLE;
      
    endcase
  end    
  
  assign o_RX_DV   = r_RX_DV;
  assign o_RX_Byte = r_RX_Byte;
  
endmodule // UART_RX



module my_testbench();
    localparam period = 5;
    localparam CLKS_PER_BIT = 867; //(100000000/115200)= 868 (Clock Frequency = 100MHz) 
    
    reg clk_in1_0 = 0;
    reg reset;
    reg rs232_uart_rxd; //UART input
    wire rs232_uart_txd; //UART output
    
    wire o_RX_DV;
    wire [7:0] o_RX_Byte;
    wire clk_out;
    
    //generic_intf_1 rs232_uart();
    uart_1_0_0000 rs232_uart();
    /*design_1_wrapper DUT(
                          .clk_in1_0(clk_in1_0),
                          .reset(reset),
                          .rs232_uart_rxd(rs232_uart_rxd),
                          .rs232_uart_txd(rs232_uart_txd)
                        );*/
    /*design_1_wrapper DUT
                       (
                            .reset(reset),
                            .rs232_uart_rxd(rs232_uart_rxd),
                            .rs232_uart_txd(rs232_uart_txd),
                            .clk_out(clk_out)
                            //.sys_diff_clock_clk_n(clk_in1_0),
                            //.sys_diff_clock_clk_p(clk_in1_0)
                        );*/
                    
    design_1_wrapper DUT
           //  design_1 DUT
                       (
                            .reset(reset),
                            .rs232_uart(rs232_uart.master),
                            .clk_out(clk_out)
                            //.sys_diff_clock_clk_n(clk_in1_0),
                            //.sys_diff_clock_clk_p(clk_in1_0)
                        );
                        
    UART_RX #(.CLKS_PER_BIT(CLKS_PER_BIT)) receiver(
                       //.i_Clock(clk_in1_0),
                       .i_Clock(clk_out),
                       //.i_RX_Serial(rs232_uart_txd),
                       .i_RX_Serial(rs232_uart.TxD),
                       .o_RX_DV(o_RX_DV),
                       .o_RX_Byte(o_RX_Byte)
                    );
    
    always #(period/2)clk_in1_0 = ~clk_in1_0;
    
    initial begin
      reset = 1; //resetting the system  
      #10;
      reset =0; 
      
      //#20000000 
      //#20000000
      #20000000
      $finish; 
    end
    
    always@(o_RX_DV)
    begin
      if(o_RX_DV == 1'b1)
        $display($time,"  %s",o_RX_Byte );
    end
    
    
endmodule
