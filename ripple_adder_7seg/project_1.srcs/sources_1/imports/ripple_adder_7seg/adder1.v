`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/25/2025 11:29:01 PM
// Design Name: 
// Module Name: adder
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
module adder(
    input a,
    input b,
    input cin,
    output sum,
    output cout
    );  
    assign {cout, sum} =  a + b + cin;
    
endmodule

module ripple_carry_adder1 #( parameter DATA_WIDTH=3)
    (
        input [DATA_WIDTH-1:0]a,
        input [DATA_WIDTH-1:0] b,
        input cin,
        output [DATA_WIDTH-1:0] sum,
        output cout
    );
    wire [DATA_WIDTH:0] carry;
    assign carry[0] = cin;

    genvar i;
    generate
        for ( i = 0; i < DATA_WIDTH; i = i+1) 
        begin : full_adder_chain
        
            (* DONT_TOUCH = "true" *) adder fa (
                .a(a[i]),
                .b(b[i]),
                .cin(carry[i]),
                .sum(sum[i]),
                .cout(carry[i+1])
            );
        end
    endgenerate
    
    assign cout = carry[DATA_WIDTH];
endmodule
