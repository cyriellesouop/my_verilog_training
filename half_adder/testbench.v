`timescale 1ns/1ps

module testbench;

	reg a;
	reg b;
	wire sum;
	wire carry;

	reg [2:0] i;

	half_adder DUT (
		.a(a),
		.b(b),
		.sum(sum),
		.carry(carry)
       	);


        initial begin
                for (i=0 ; i<= 3; i = i+1) begin
             //           {a,b} = i;
	     		{a,b} = i[1:0];
                        #5;
                        $display("\t a %b , b %b =   sum %b |  carry %b ", a, b, sum , carry);

                end
                #5;

		a = 1;
                b= 1'bx;
                #2;
		 $display("\t a %b , b %b =   sum %b |  carry %b ", a, b, sum, carry);

                a = 0;
                b = 1'bx;
                #2;
		 $display("\t a %b , b %b =   sum %b |  carry %b ", a, b, sum, carry);

                a = 1;
                b= 1'bz;
                #2;
		 $display("\t a %b , b %b =   sum %b |  carry %b ", a, b, sum, carry);

                a = 0;
                b = 1'bz;
                #2;
		 $display("\t a %b , b %b =   sum %b |  carry %b ", a, b, sum, carry);

		
		 // b is known and has either 0 or 1
		b= 1;
                a= 1'bx;
                #2;
                 $display("\t a %b , b %b =   sum %b |  carry %b ", a, b, sum, carry);

                b = 0;
                a = 1'bx;
                #2;
                 $display("\t a %b , b %b =   sum %b |  carry %b ", a, b, sum, carry);

                b = 1;
                a= 1'bz;
                #2;
                 $display("\t a %b , b %b =   sum %b |  carry %b ", a, b, sum, carry);

                b = 0;
                a = 1'bz;
                #2;
                 $display("\t a %b , b %b =   sum %b |  carry %b ", a, b, sum, carry);


	end
endmodule
