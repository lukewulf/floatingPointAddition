module addRippleN_tb;

	logic [3:0] a, b, c;
	logic op, cOut, cPenult;

	addRippleN #(4) ripple4(.a(a), .b(b) ,.op(op), .c(c), .cOut(cOut), .cPenult(cPenult));
	initial begin

	a = 4'b0110;
	b = 4'b0110;
	op = 1'b0;

	#50;
	a = 4'b0100;
	b = 4'b0111;
	op = 1'b1;

	#50;
	a = 4'b0110;
	b = 4'b0101;
	// underflow large case

	#50;
	a = 4'b0100;
	b = 4'b0010;
	op = 1;
	
	// negative overflow

	end

endmodule
