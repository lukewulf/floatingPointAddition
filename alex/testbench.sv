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

wire [31:0] gt, lt;
wire [7:0]  e_dif;
wire flip;

logic [24:0] m_tst;
logic [ 7:0] e_tst;

wire  [22:0] m_res;
wire  [ 4:0] m_exp;
wire  [23:0] sh_tst;

initial begin
    clk = 0;
    rst = 0;
    op  = 0;

    a_s = 0; a_e = 0; a_m = 0;
    b_s = 0; b_e = 0; b_m = 0;

    #4; a_e = 8'd127; b_e = 8'd127; op = 0; #1; $display("%h + %h = %h", a, b, c);
    #4; b_s = 1; #1; $display("%h + %h = %h", a, b, c);
    #4; a_s = 1; b_s = 0; #1; $display("%h + %h = %h", a, b, c);
    #4; b_s = 1; #1; $display("%h + %h = %h", a, b, c);
    #4; a_s = 0; b_s = 0; op = 1; #1; $display("%h + %h = %h", a, b, c);
    #4; b_s = 1; #1; $display("%h + %h = %h", a, b, c);
    #4; a_s = 1; b_s = 0; #1; $display("%h + %h = %h", a, b, c);
    #4; b_s = 1; #1; $display("%h + %h = %h", a, b, c);
end

/*
float_cmp fcmp(
    .a(a), .b(b),
    .gt(gt), .lt(lt),
    .e_dif(e_dif),
    .flip(flip)
);
*/

fp_13 fpu(
    .clk(clk), .rst(rst),
    .op(op),
    .a(a), .b(b),
    .c(c)
);

/*
initial begin
    m_tst = 25'h0000000;
    e_tst = 8'h00;

    #5; m_tst = 25'h1000001; e_tst = 8'h01;
    #5; m_tst = 25'h0800001; e_tst = 8'h02;
    #5; m_tst = 25'h0400001; e_tst = 8'h10;
    #5; m_tst = 25'h0200001; e_tst = 8'h80;
    #5; m_tst = 25'h0100001; e_tst = 8'h01;
    #5; m_tst = 25'h0080001;
    #5; m_tst = 25'h0040001;
    #5; m_tst = 25'h0000211;
    #5; m_tst = 25'h023456;
end

mantissa_positioner m_pos(
    .m(m_tst),
    .r(m_res),
    .e(m_exp)
);

mantissa_shifter m_shift(
    .e( e_tst),
    .m( m_tst[23:0]),
    .o(sh_tst)
);
*/
endmodule