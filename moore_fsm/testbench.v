`timescale 1ns/1ps

module testbench;

    parameter OPCODE_WIDTH = 2;
    parameter DATA_WIDTH = 9;
    parameter STATE_WIDTH = 3;

    reg clk=0;
    reg rstn;
    reg [OPCODE_WIDTH-1:0] opcode;
    reg [DATA_WIDTH-1:0]opa;
    reg [DATA_WIDTH-1:0] opb;
    reg wr;
    wire done;
    wire status;
    wire [DATA_WIDTH-1:0] res;

    integer i,a,b;
    reg validate ;


    function reg verification (
	input [OPCODE_WIDTH-1:0] opcode,
        input [DATA_WIDTH-2:0] opa,
        input [DATA_WIDTH-2:0] opb,
        input [DATA_WIDTH-1:0] res
    );

    	reg [DATA_WIDTH-1:0] result;

	begin

	if (opcode == 2'b00)
		result = opa + opb;

	else if (opcode == 2'b01)
		result = opa - opb;

	else if (opcode == 2'b10)
		result = opa >> opb;

	else if (opcode == 2'b11)
		result = opa << opb;
	else
		result = 2'bxx;
	 
	verification = (result == res);
	       

	end
    endfunction
   
    alu  #(.OPCODE_WIDTH(OPCODE_WIDTH), .DATA_WIDTH(DATA_WIDTH), .STATE_WIDTH(STATE_WIDTH))
   	 DUT (
        .clk(clk), .rstn(rstn), .opa(opa), .opb(opb), .opcode(opcode) , 
        .wr(wr), .done(done), .status(status), .res(res)
    );



    always #2 clk = ~clk;

     initial begin : test
    
   	rstn = 0;
        wr = 0;
        opcode = 0;
        opa = 0;
        opb = 0;

        #10;
        rstn = 1;
	// $monitor( $time ,  " Opcode=%b , opa=%d, opb=%d  =>  res=%d,  done=%b ,  status=%b  ",   opcode,opa, opb, res, done, status);

        for (i = 0; i < (2**OPCODE_WIDTH); i = i + 1) begin
            opcode = i[OPCODE_WIDTH-1:0];
           for (a = 0; a < (2**(DATA_WIDTH-1)); a = a + 1) begin
	        opa = a[DATA_WIDTH-2:0];

                for (b = 0; b < (2**(DATA_WIDTH-1)); b = b + 1) begin
                    opb = b[DATA_WIDTH-2:0];
                    wr = 1;
		    wait (done == 0);
                    wait (done == 1);
		    validate = verification(opcode , opa, opb, res);

		    if (!validate)
		    begin
			    $display("Error arise during the simulation!!");
			    $display("opcode = %b, opa = %d, opb = %d,  actual = %d",
                          opcode, opa, opb, res);
		    	    disable test;
		    end	    
                end
            end
        end


        $display ("All tests has passed");
	$finish;
                    
end

endmodule

