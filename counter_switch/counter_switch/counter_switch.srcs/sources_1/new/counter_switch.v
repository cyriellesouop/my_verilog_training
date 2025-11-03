`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/30/2025 04:47:18 PM
// Design Name: 
// Module Name: counter_switch
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




module counter_switch(
    input clk,
    input rstn,
    input [1:0] switch,
    output reg [7:0] counter

    );
    
    always @ (posedge clk) 
    begin
    
        if (rstn == 0 ) 
            begin
                counter = 0;
            end
        
        else
            if (switch == 2'b00)
                counter = counter + 1 ;
            else if (switch == 2'b01)
                counter = counter - 1;
            else if (switch == 2'b11)
                counter = counter;
        
        
    end
endmodule
