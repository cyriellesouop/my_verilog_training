`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/03/2025 04:34:19 PM
// Design Name: 
// Module Name: reset
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


module reset(
    input clk,
    input reset_n
 )

    reg [7:0] data;

    always @(posedge clk)
    begin
        if (!reset_n) //active low reset
            data <= 8'b0;
        else
            data <= //update data based on input ports
    end

endmodule
