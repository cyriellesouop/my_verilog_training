`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/02/2025 10:54:19 PM
// Design Name: 
// Module Name: testbench
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


module testbench();

    reg clk=0;
    reg rstn = 0;
    reg [3:0] number = 4'b0010;
    wire [3:0] max; 
    
    always #2 clk = ~clk;
    
    
    max DUT (clk, rstn, number, max);
    
    
    initial 
    begin
        
        #4 rstn = 1;
        
        
       number = 4'b0000;
      
        #4
        number = 4'b0011;
        
        #4;
        number = 4'b0011;
       
        #4 ;
        number = 4'b1100;
        
        #4 ;
        number = 4'b0111;
        #4 ;
        number = 4'b0001;
        #4 ;
        number = 4'b0100;   
        #4 ;
        number = 4'b1101;
        #4 ;
        number = 4'b1110;
        #4 ;
        number = 4'b1111;
        #4


    
    $stop;
    end
    
    initial begin
     $monitor($time ," max = %0d  is", max);
    
    end
endmodule