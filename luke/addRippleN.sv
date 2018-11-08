module addRippleN
	#(parameter width = 8)
	(input logic [width-1:0] a,
	 input logic [width-1:0] b,
	 input logic op,
	 output logic [width-1:0] c,
	 output logic cOut,
	 output logic cPenult);
	
	wire [width:0] carry;
	assign carry[0] = op;
	
	
	generate
		genvar i;
		
		for(i = 0; i < width; i = i+1)
		begin : genFA
			fullAdder f(.a(a[i]), .b(b[i]),
				    .op(op), .cIn(carry[i]), 
				    .cOut(carry[i+1]), .c(c[i]));
		end
	endgenerate

	assign cOut = carry[width];
	assign cPenult = carry[width-1];

endmodule
