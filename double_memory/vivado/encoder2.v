`timescale 1ns/1ps


module Encoder2 (           
    input [2:0] addrIn,        
    output [3:0] addrEncoded
    
);
	assign addrEncoded = addrIn + 4'b1000 ;

endmodule
