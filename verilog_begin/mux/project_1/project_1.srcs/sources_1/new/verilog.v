`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/24/2025 10:43:51 PM
// Design Name: 
// Module Name: verilog
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


module verilog(
    input A ,
    input B,
    input S, 
    output reg C

    );
    // Structural modeling
//    wire temp1 ;
//    wire temp2;
    
//    assign temp1 = ~S & A ; 
//    assign temp2 = S & B; 
//    assign C = temp1 | temp2;

    // Behavioral modeling
    always @(A or B or S)
    begin 
        if ( S==0 )
            C = A ;
        else 
            C = B;
    
    
    end
    
endmodule
