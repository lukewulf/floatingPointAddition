module testbench;

logic clk, rst;
logic op;

logic        a_s, b_s;
logic [ 7:0] a_e, b_e;
logic [22:0] a_m, b_m;
wire [31:0] a, b;
wire  [31:0] c;
wire        c_s;
wire [ 7:0] c_e;
wire [22:0] c_m;
assign {c_s, c_e, c_m} = c;

assign a = {a_s, a_e, a_m};
assign b = {b_s, b_e, b_m};

initial begin
    clk = 0;
    rst = 0;
    op  = 0;

    a_s = 0; a_e = 0; a_m = 0;
    b_s = 0; b_e = 0; b_m = 0;

    #4; a_e = 8'd131; b_e = 8'd127; op = 0; #1;
    $display("%h + %h = %h", a, b, c);
    #4; b_s = 1; #1; $display("%h + %h = %h", a, b, c);
    #4; a_s = 1; b_s = 0; #1; $display("%h + %h = %h", a, b, c);
    #4; b_s = 1; #1; $display("%h + %h = %h", a, b, c);
    #4; a_s = 0; b_s = 0; op = 1; #1; $display("%h - %h = %h", a, b, c);
    #4; b_s = 1; #1; $display("%h - %h = %h", a, b, c);
    #4; a_s = 1; b_s = 0; #1; $display("%h - %h = %h", a, b, c);
    #4; b_s = 1; #1; $display("%h - %h = %h", a, b, c);
end

fp_13 fpu(
    .clk(clk), .rst(rst),
    .op(op),
    .a(a), .b(b),
    .c(c)
);

endmodule