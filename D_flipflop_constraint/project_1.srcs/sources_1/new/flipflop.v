`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/24/2025 10:46:08 PM
// Design Name: 
// Module Name: flipflop
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


module flipflop(
    input clk,
    input rst,
    input d,
    output q
    );
    
    reg my_reg;
    
    always @(posedge clk or posedge rst) begin
    
    if( rst)
        my_reg <= 1'b0;
    else
        my_reg <= d;
    end
    
    assign q = my_reg;    
endmodule
