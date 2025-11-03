`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/27/2025 11:08:33 PM
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
    wire [3:0] counter; 
    
    always #2 clk = ~clk;
    
    count_op DUT(clk, rstn, counter);
    
    initial 
    begin
        
        #10 rstn = 1;
        $monitor($time ," count = %b", counter);
    
    end
    
endmodule
