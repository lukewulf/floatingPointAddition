module normalizer #(parameter norm = 1)(
		  input [24:0] a,
		  input [7:0] exp,
		  output [22:0] mantissa2,
		  output [7:0] outEx2);
	
	logic [22:0] mantissa;
	logic [7:0] outEx;

	always_comb
	casex(a)
		25'b1_xxxx_xxxx_xxxx_xxxx_xxxx_xxxx: begin
			mantissa = a[23:1];
			outEx = exp + norm + 1;
		end
		25'b0_1xxx_xxxx_xxxx_xxxx_xxxx_xxxx: begin
			mantissa = a[22:0];
			outEx = exp + norm;
		end
		25'b0_01xx_xxxx_xxxx_xxxx_xxxx_xxxx: begin
			 mantissa = {a[21:0], {1{1'b0}}};
			outEx = exp + norm - 1;
		end
		25'b0_001x_xxxx_xxxx_xxxx_xxxx_xxxx: begin
			mantissa = {a[20:0], {2{1'b0}}};
			outEx = exp + norm - 2;
		end
		25'b0_0001_xxxx_xxxx_xxxx_xxxx_xxxx: begin
			mantissa = {a[19:0], {3{1'b0}}};
			outEx = exp + norm - 3;
		end
		25'b0_0000_1xxx_xxxx_xxxx_xxxx_xxxx: begin 
			mantissa = {a[18:0], {4{1'b0}}};
			outEx = exp + norm - 4;
		end
		25'b0_0000_01xx_xxxx_xxxx_xxxx_xxxx: begin
			mantissa = {a[17:0], {5{1'b0}}};
			outEx = exp + norm -5;
		end
		25'b0_0000_001x_xxxx_xxxx_xxxx_xxxx: begin
			mantissa = {a[16:0], {6{1'b0}}};
			outEx = exp + norm -6;
		end
		25'b0_0000_0001_xxxx_xxxx_xxxx_xxxx: begin
			mantissa = {a[15:0], {7{1'b0}}};
			outEx = exp + norm -7;
		end
		25'b0_0000_0000_1xxx_xxxx_xxxx_xxxx: begin
			outEx = exp + norm - 8;
			mantissa = {a[14:0], {8{1'b0}}};
		end
		25'b0_0000_0000_01xx_xxxx_xxxx_xxxx: begin
			mantissa = {a[13:0], {9{1'b0}}};
			outEx = exp + norm - 9;
		end
		25'b0_0000_0000_001x_xxxx_xxxx_xxxx: begin
			mantissa = {a[12:0], {10{1'b0}}};
			outEx = exp + norm - 10;
		end
		25'b0_0000_0000_0001_xxxx_xxxx_xxxx: begin
			mantissa = {a[11:0], {11{1'b0}}};
			outEx = exp + norm -11;
		end
		25'b0_0000_0000_0000_1xxx_xxxx_xxxx: begin
mantissa = {a[10:0], {12{1'b0}}};
outEx = exp + norm - 12;
end
		25'b0_0000_0000_0000_01xx_xxxx_xxxx: begin
mantissa = {a[9:0], {13{1'b0}}};
outEx = exp + norm -13;
end
		25'b0_0000_0000_0000_001x_xxxx_xxxx: begin
mantissa = {a[8:0], {14{1'b0}}};
outEx = exp + norm - 14;
end
		25'b0_0000_0000_0000_0001_xxxx_xxxx: begin
mantissa = {a[7:0], {15{1'b0}}};
outEx = exp + norm - 15;
end
		25'b0_0000_0000_0000_0000_1xxx_xxxx: begin
mantissa = {a[6:0], {16{1'b0}}};
outEx = exp + norm - 16;
end
		25'b0_0000_0000_0000_0000_01xx_xxxx: begin
mantissa = {a[5:0], {17{1'b0}}};
outEx = exp + norm - 17;
end
		25'b0_0000_0000_0000_0000_001x_xxxx: begin
mantissa = {a[4:0], {18{1'b0}}};
outEx = exp + norm - 18;
end
		25'b0_0000_0000_0000_0000_0001_xxxx: begin
mantissa = {a[3:0], {19{1'b0}}};
outEx = exp + norm - 19;
end
		25'b0_0000_0000_0000_0000_0000_1xxx: begin
mantissa = {a[2:0], {20{1'b0}}};
outEx = exp + norm - 20;
end
		25'b0_0000_0000_0000_0000_0000_01xx: begin
mantissa = {a[1:0], {21{1'b0}}};
outEx = exp + norm - 21;
end
		25'b0_0000_0000_0000_0000_0000_001x: begin
mantissa = {a[0], {22{1'b0}}};
outEx = exp + norm - 22;
end
		25'b0_0000_0000_0000_0000_0000_0001: begin
mantissa = {23{1'b0}};
outEx = exp + norm - 23;
end
		default: begin
mantissa = {23{1'b0}};
outEx = 8'b0000_0000;
end
	endcase

	assign mantissa2 = mantissa;
	assign outEx2 = outEx;
endmodule
		
