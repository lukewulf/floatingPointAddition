module fp_xx(
input clk, rst,
input op,
input [31:0] a, b,
output logic [31:0] c);


	wire aSign = a[31];
	wire [7:0] aExp = a[30:23];
	wire [24:0] aMant = {2'b01, a[22:0]};
	wire [24:0] aOp;

	wire bSign = b[31];
	wire [7:0] bExp = b[30:23];
	wire [24:0] bMant = {2'b01, b[22:0]};
	wire [24:0] bOp;

	wire [7:0] cA;
	wire [7:0] cB;

	wire cExpOut;
	wire cExpPenult;
	wire junkC1, junkC2;

	// compare exponents
	addRippleN #(8) cmpA(.a(aExp), .b(bExp), .op(1'b1), .c(cA), .cOut(cExpOut), .cPenult(cExpPenult));
	addRippleN #(8) cmpB(.a(bExp), .b(aExp), .op(1'b1), .c(cB), .cOut(junkC1), .cPenult(junkC2));

	// if exponents are equal, have to check mantissa
	wire cExpFin = |cA ? cExpOut : aMant > bMant;

	// normalize mantissa
	assign aOp = cExpFin ? aMant : aMant >> cB;
	assign bOp = cExpFin ? bMant >> cA : bMant;

	// mantissa Adder
	wire [24:0] mantC;
	wire [24:0] mantOut;
	wire mantOp, mantFin, mantPenult;

	// if signs are odd than subtract due to sign magnitude of fp, else add
	assign mantOp = aSign ^ bSign ^ op;

	addRippleN #(25) mantAdder(.a(aOp), .b(bOp), .op(mantOp), .c(mantC), .cOut(mantFin), .cPenult(mantPenult));
	
	assign mantOut = mantC;

	// now mantC should be the correct mantissa, time to calculate final sign using kMap
	 wire finalSign;
 	 assign finalSign = (bSign & ~op & ~cExpFin) | (aSign & cExpFin) | (~bSign &  op & ~cExpFin);

	// flip back mantissa if negative
	wire [24:0] flippedMant1;
	wire [24:0] flippedMant;
	assign flip = (aSign & bSign & ~op) | (aSign & ~bSign & op);  
	assign flippedMant1 = finalSign ? ({25{1'b1}} ^ mantOut) + 1 : mantOut;
	assign flippedMant = flip ? mantOut : flippedMant1;
	
	// now mantissa is back in positive form regardless of sign, now you must loop from msb to lsb counting how far down the first zero is.
	// encode the next 23 bits after the one as the new mantissa 
	
	wire [7:0] normExp;
	assign normExp = cExpFin ? aExp : bExp;
	wire [22:0] normMant;
	wire [7:0] normC;

	normalizer #(0) n(.a(flippedMant), .exp(normExp), .mantissa2(normMant), .outEx2(normC));
	
	assign c = {finalSign, normC, normMant};
		
endmodule
