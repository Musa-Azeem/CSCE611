module hexdriver (input [3:0] val, output logic [6:0] HEX);
	always_comb begin
                case (val)
                        4'h0: HEX = 7'b0000001;
                        4'h1: HEX = 7'b1001111;
                        4'h2: HEX = 7'b0010010;
                        4'h3: HEX = 7'b0000110;
                        4'h4: HEX = 7'b1001100;
                        4'h5: HEX = 7'b0100100;
                        4'h6: HEX = 7'b0100000;
                        4'h7: HEX = 7'b0001111;
                        4'h8: HEX = 7'b0000000;
                        4'h9: HEX = 7'b0000100;
                        4'hA: HEX = 7'b0001000;
                        4'hB: HEX = 7'b1100000;
                        4'hC: HEX = 7'b0110001;
                        4'hD: HEX = 7'b1000010;
                        4'hE: HEX = 7'b0110000;
                        4'hF: HEX = 7'b0111000;
                endcase
        end
endmodule
