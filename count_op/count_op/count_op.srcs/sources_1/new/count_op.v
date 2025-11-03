`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/27/2025 10:32:15 PM
// Design Name: 
// Module Name: count_op
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


module count_op(
    input clk,
    input rstn,
    output reg [3:0] counter

    );
    
    always @ (posedge clk) 
    begin
    
        if (rstn == 0 ) 
            counter = 0;
        else
            counter = counter + 1 ;
        
        
    end
endmodule
