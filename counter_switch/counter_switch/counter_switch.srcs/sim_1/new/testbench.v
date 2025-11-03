`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/30/2025 06:29:30 PM
// Design Name: 
// Module Name: testbench
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


module testbench();

    reg clk=0;
    reg rstn = 0;
    reg [1:0] switch = 2'b00;
    wire [7:0] counter; 
    
    always #2 clk = ~clk;
    
    counter_switch DUT(clk, rstn, switch, counter);
    
    initial 
    begin
        
        #10 rstn = 1;
        
        
        switch = 2'b00;
      
        #50
        switch = 2'b01;
        #5000;
       
        #10 ;
        switch = 2'b11;
        
        #10 ;
        switch = 2'b10;
        #100 ;
//        #3 ;
//        switch = 2'b01;
//        #3 ;
//        switch = 2'b01;
        
//        #3; 
//        switch = 2'b11;
       
        
//        #5 
        
//        switch = 2'b00;
//        #5 ;
//        $monitor($time ," count = %0d  and switch = %b", counter , switch);
        
        
    $stop;
    end
    
    initial begin
     $monitor($time ," count = %0d  and switch = %b", counter , switch);
    
    end
endmodule
