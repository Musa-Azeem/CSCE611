module hexdriver (input [3:0] val, output logic [6:0] HEX);

	assign w = val[0];
	assign x = val[1];
	assign y = val[2];
	assign z = val[3];

	assign HEX[0] = w | y | (x & z) | (~x | ~z);
	assign HEX[1] = ~x | (y & z) | (~y & ~z);
	assign HEX[2] = x | ~y | z;
	assign HEX[3] = (~x & ~z) | (y & ~z) | (~x & y) | (~y & z);
	assign HEX[4] = (~x & ~z) | (y & ~z);
	assign HEX[5] = w | x | (~y & ~z);
	assign HEX[6] = w | (~x & y) | (x & ~y) | (x & ~z);


endmodule
