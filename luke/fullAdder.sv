module fullAdder(
	input a,
	input b,
	input cIn,
	input op,
	output cOut,
	output c);
	
	wire bOp = b ^ op;
	
	assign c = a ^ bOp ^ cIn;
	assign cOut = (a & bOp) | (cIn & bOp) | (cIn & a);

endmodule
