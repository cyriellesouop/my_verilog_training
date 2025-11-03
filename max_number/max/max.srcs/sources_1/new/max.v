`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/02/2025 03:09:47 PM
// Design Name: 
// Module Name: max
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


module max(
    input clk,
    input rstn,
    input [3:0] number, 
    output reg [3:0] max

    );
    
        always @ (posedge clk or rstn) 
    begin
    
        if (rstn == 0 ) 
            begin
                max = 4'b0000;
            end
        
        else 
            if (number > max)
                max = number ;
            else if (max <= number)
                max = max;
        
         end
endmodule
