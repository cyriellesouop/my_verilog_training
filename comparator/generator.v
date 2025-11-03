`timescale 1ns/1ps

module generator
#( parameter N = 4)
(
    input  [N-1:0] a,
    input  [N-1:0] b,
    output wire z
);

    wire [N-1:0] s;

    genvar i;
    generate
        for (i = 0; i < N; i = i+1) 
	begin 
            comparator CA (
                .a(a[i]),
                .b(b[i]),
                .s(s[i])
            );
        end
    endgenerate
    assign z = &s;

endmodule

