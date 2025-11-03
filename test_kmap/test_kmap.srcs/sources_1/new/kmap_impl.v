`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/17/2025 08:15:07 PM
// Design Name: 
// Module Name: kmap_impl
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


module kmap_impl(
    input a,
    input b,
    input c,
    output reg  y,
    output reg  z
    );
    
  
// Structural modeling
    
//    wire temp ;
    
//    assign temp = b & c ; 
//    assign y = a | temp; 
//    assign z = c | b;

   
// Behavioral modeling      
    always@ ( a || b || c) begin 
        
        if (a==1)
            y=1;
        else if (b==1 && c==1)
            y=1;
        else    
            y=0;
            
        if(b==1 || c==1)
            z=1;
        else 
            z=0;
end;
endmodule


