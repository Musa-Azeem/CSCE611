module hexdriver (input [3:0] val, output logic [6:0] HEX);

	// assign w = val[0];
	// assign x = val[1];
	// assign y = val[2];
	// assign z = val[3];

	// assign HEX[0] = w | y | (x & z) | (~x | ~z);
	// assign HEX[1] = ~x | (y & z) | (~y & ~z);
	// assign HEX[2] = x | ~y | z;
	// assign HEX[3] = (~x & ~z) | (y & ~z) | (~x & y) | (~y & z);
	// assign HEX[4] = (~x & ~z) | (y & ~z);
	// assign HEX[5] = w | x | (~y & ~z);
	// assign HEX[6] = w | (~x & y) | (x & ~y) | (x & ~z);

	always_comb begin
                case (in)
                        4'h0: out = 7'b1000000;
                        4'h1: out = 7'b1111001;
                        4'h2: out = 7'b0100100;
                        4'h3: out = 7'b0110000;
                        4'h4: out = 7'b0011001;
                        4'h5: out = 7'b0010010;
                        4'h6: out = 7'b0000010;
                        4'h7: out = 7'b1111000;
                        4'h8: out = 7'b0000000;
                        4'h9: out = 7'b0010000;
                        4'hA: out = 7'b0001000;
                        4'hB: out = 7'b0000011;
                        4'hC: out = 7'b1000110;
                        4'hD: out = 7'b0100001;
                        4'hE: out = 7'b0000110;
                        4'hF: out = 7'b0001110;
                endcase
        end
endmodule
