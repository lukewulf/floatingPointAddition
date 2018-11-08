module fp_xx_tb;

	logic [31:0] a, b, c;
	logic clk, rst, op;

	fp_xx uut(.a(a), .b(b), .op(op), .clk(clk), .rst(rst), .c(c));

	initial begin
		// positive + positive: 1+1 = 2
		a = 32'h3f800000;
		b = 32'h3f800000;
		clk = 1'b0;
		rst = 1'b0;
		op = 1'b0;
		$display("positive + positive");
		$display("A: %h", a);
		$display("B: %h", b);
		#10;
		$display("C: %h", c);
		
		#50;
		
		// pos + neg  4 + (-7)
		a = 32'h40800000;
		b = 32'hc0e00000;	
		$display("positive + negative");
		$display("A: %h", a);
		$display("B: %h", b);
		#10;
		$display("C: %h", c);


		#50;

		// neg + neg (-10) + (-10)
		a = 32'hc1200000;
		b = 32'hc1200000;
		$display("negative + negative");
		$display("A: %h", a);
		$display("B: %h", b);
		#10;
		$display("C: %h", c);

		#50;
		// neg + pos (-10) + 10
		b = 32'h41200000;
		$display("negative + positive");
		$display("A: %h", a);
		$display("B: %h", b);
		#10;
		$display("C: %h", c);

		#50;

		// pos - pos 10 - 5 = 5
		a = 32'h41200000;
		b = 32'h40a00000;
		op = 1'b1;
		$display("positive - positive");
		$display("A: %h", a);
		$display("B: %h", b);
		#10;
		$display("C: %h", c);

		#50;

		// pos - neg 7 - (-4) = 11
		a = 32'h40e00000;
		b = 32'hc0800000;
		$display("positive - negative");
		$display("A: %h", a);
		$display("B: %h", b);
		#10;
		$display("C: %h", c);

		#50;

		// neg - pos -4 - 7 = -11
		a = 32'hc0800000;
		b = 32'h40e00000;
		$display("negative - positive");
		$display("A: %h", a);
		$display("B: %h", b);
		#10;
		$display("C: %h", c);

		#50;

		// neg - neg -7 - (-7) = 0
		a = 32'h40e00000;
		$display("negative - negative");
		$display("A: %h", a);
		$display("B: %h", b);
		#10;
		$display("C: %h", c);
	end
endmodule
