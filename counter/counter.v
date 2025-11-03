`timescale 1ns/1ps


module counter 
#(

parameter DATA_WIDTH = 4
)

(
input clk,
input rstn,
input direction,
output reg [DATA_WIDTH-1 : 0] count
);


reg clk_tmp;
reg [3 : 0] counter;


always @(posedge clk)
    begin
        if(~rstn)
            begin
               clk_tmp <= 0;
               counter <= 0;
             end
        else
          begin

             counter <= counter + 1;

             if (counter == 3)
                begin
                   clk_tmp <= ~ clk_tmp;
                   counter <= 0;
               end
          end
    end

always @(posedge clk_tmp )
begin
	if (~rstn)
		count <=0;

	else 
	begin 
		if (direction)
			count <= count +1;

		else 
			count <= count - 1;
	end
end
endmodule
