`timescale 1ns/1ps

module tb_encoder;

	integer i;
	reg [2:0] addrIn;
	wire [3:0] addrEncoded1, addrEncoded2;

	Encoder1 DUT1(
		addrIn,
		addrEncoded1
	);

	 Encoder2 DUT2(
                addrIn,
                addrEncoded2
        );


	initial begin
		
		for(i=0; i <= (2**3)-1 ; i=i+1)	
			#2 addrIn = i;
			 

	

	initial begin
		$monitor($time, "  addrIn = %b , addrEncoded1 = %b  , addrEncoded2 = %b ", addrIn, addrEncoded1 , addrEncoded2 );



	end

	endmodule

