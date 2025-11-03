`timescale 1ns/1ps


module Encoder1 (           
    input [2:0] addrIn,        
    output [3:0] addrEncoded
    
);
	assign addrEncoded = {1'b0, addrIn};

endmodule
