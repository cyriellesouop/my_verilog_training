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

module ripple_carry_adder #( parameter N=8)
    (
        input [N-1:0]a,
        input [N-1:0] b,
        input cin,
        output [N-1:0] sum,
        output cout
    );
    wire [N:0] carry;
    assign carry[0] = cin;

    genvar i;
    generate
        for ( i = 0; i < N; i = i+1) 
        begin : full_adder_chain
        
            adder fa (
                .a(a[i]),
                .b(b[i]),
                .cin(carry[i]),
                .sum(sum[i]),
                .cout(carry[i+1])
            );
        end
    endgenerate
    
    assign cout = carry[N];
endmodule
