module fullAdder_tb;

	logic a, b, cIn, op;

	logic cOut, c;

	fullAdder uut(.a(a), .b(b), .cIn(cIn), .cOut(cOut), .c(c));

	initial begin

	a = 1'b0;
	b = 1'b0;
	cIn = 1'b1;

	#50

	a = 1'b1;

	#50

	b = 1'b1;

	#50

 	cIn = 1'b0;
	
	end
endmodule
