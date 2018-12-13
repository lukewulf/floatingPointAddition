import definitions::*;

module top;

logic clk, rst, op, flag_i;

Float32 a, b, c;
wire flag_o;

wire [31:0] hex_a, hex_b, hex_c;
assign hex_a = a;
assign hex_b = b;
assign hex_c = c;

always begin
    clk = 0; #5;
    clk = 1; #5;
end

initial begin
    a  = 32'h3fc00000;  // 1.5
    b  = 32'h3fc00000;  // 1.5
    op = 0;             // expect: 3 = 32'h40400000

    #10;

    flag_i = 1;
    b = 32'h3f800000;   // 1
                        // expect: 2.5 = 32'h40200000

    #10;

    op = 1;             // expect: 0.5 = 32'h3f000000         

    #10;

    a = 32'h41700000;   // 15
    b = 32'h41500000;   // 13
                        // expect: 2 = 32'h40000000

    #10;

    a = 32'h39ebedfa;  // 0.00045
    b = 32'h3827c5ac;  // 0.00004
                       // expect: 0.00041 = 32'h39d6f545

    #10;

    op = 0;            // expect: 0.00049 = 32'h3a007358
end

fp_13 fpu(
    .clk(clk),
    .rst(rst),
    .flag_i(flag_i),

    .op(op),
    .a(a),
    .b(b),
    .c(c),
    .flag_o(flag_o)
);

endmodule