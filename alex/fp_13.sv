module fp_13(
    input           clk, rst,
    input                 op,
    input        [31:0] a, b,
    output logic [31:0]    c
);

wire [31:0] gt, lt;
wire [23:0] lt_m, _lt_m;
wire [7:0]  e_dif;

wire flip;

// compare the operands and determine which is bigger
float_cmp f_cmp(
    .a(a),   .b(b),
    .gt(gt), .lt(lt),
    .e_dif(e_dif),
    .flip(flip)
);

// split the greater-than float into components
wire         gt_s;
wire [ 7:0]  gt_e;
wire [22:0] _gt_m;
wire [23:0]  gt_m;
float_splitter gt_split(
    .f(gt), .s(gt_s), .e(gt_e), .m(_gt_m)
);

wire [7:0] lt_e;
assign lt_e = lt[30:23];

// add the implicit leading 1
// handle edge case for 0.00
wire gt_lead, lt_lead;
assign gt_lead = |{gt_e, _gt_m};
assign lt_lead = |{lt_e, lt[22:0]};

assign  gt_m = {gt_lead, _gt_m};
assign _lt_m = {lt_lead,  lt[22:0]};

// extract the less-than sign
wire lt_s;
assign lt_s = lt[31];

// ALU op determination
wire action;
assign action = gt_s ^ lt_s ^ op;

// shift the less-than mantissa to the appropriate position
mantissa_shifter shifter(
    .e(e_dif),
    .m(_lt_m),
    .o( lt_m)
);

// operate on the aligned mantissas
wire [24:0] result;
assign result = (action) ? (gt_m - lt_m) : (gt_m + lt_m);

// reposition the result
wire [4:0]  sh_amt;
wire [22:0] r_m;
mantissa_positioner m_pos(
    .m(result),
    .r(r_m),
    .e(sh_amt)
);

wire is_not_zero;
assign is_not_zero = |result;

// adjust the greater-than exponent by the amount adjusted
// add 1 to account for overflow-expanded bus
wire [7:0] c_e;
assign c_e = (is_not_zero) ? (gt_e - sh_amt + 1) : 8'b0;

// set the appropriate sign
wire c_s;
assign c_s = gt_s ^ (flip & op);

// semantics
wire [22:0] c_m;
assign c_m = r_m;

// reuse the greater-than sign, since it should never change
assign c = {c_s, c_e, c_m};

endmodule

module mantissa_shifter(
    input  [7:0]  e,
    input  [23:0] m,
    output [23:0] o
);

// barrel shifter
wire [23:0] layers [5:0];
assign layers[0] = e[0] ? {0, m[23:1]} : m;
genvar i;
for (i = 1; i < 5; i++) begin
    assign layers[i] = e[i] ? {0, layers[i-1][23:(2**i)]} : layers[i-1];
end

// any exponent too large will wipe out the whole thing
assign layers[5] = (|e[7:5]) ? 24'b0 : layers[4];

assign o = layers[5];

endmodule

module float_cmp(
    input  [31:0] a, b,
    output [31:0] gt, lt,
    output [7:0]  e_dif,
    output        flip
);

wire        a_s, b_s;
wire [7:0]  a_e, b_e;
wire [22:0] a_m, b_m;

float_splitter a_splitter(
    .f(a), .s(a_s), .e(a_e), .m(a_m)
);

float_splitter b_splitter(
    .f(b), .s(b_s), .e(b_e), .m(b_m)
);

wire e_cmp;
assign e_cmp = (a_e > b_e);

assign e_dif = (e_cmp) ? (a_e - b_e) : (b_e - a_e);

wire m_cmp;
assign m_cmp = (a_m > b_m);

wire m_priority;
assign m_priority = (e_dif == 0) & m_cmp;

assign flip = ~(e_cmp | m_priority);

assign gt = (flip) ? b : a;
assign lt = (flip) ? a : b;

endmodule


module float_splitter(
    input  [31:0] f,
    output        s,
    output [7:0]  e,
    output [22:0] m
);

assign s = f[31];
assign e = f[30:23];
assign m = f[22:0];

endmodule

module mantissa_positioner(
    input  [24:0] m,
    output [22:0] r,
    output [4:0]  e
);

wire [24:0] layers [5:0];
assign layers[5] = m;

genvar i;
for (i = 4; i >= 0; i--) begin
    parameter width  = 24 - 2**i;
    assign e[i]      = ~(|layers[i+1][24:(width + 1)]);
    assign layers[i] = (e[i]) ? {layers[i+1][width:0], {(2**i){1'b0}}} : layers[i+1] ;
end

assign r = layers[0][23:1];

endmodule
