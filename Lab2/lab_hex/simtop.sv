/* Copyright 2020 Jason Bakos, Philip Conrad, Charles Daniels */

/* Top-level module for CSCE611 RISC-V CPU, for running under simulation.  In
 * this case, the I/Os and clock are driven by the simulator. */

module simtop;

	logic clk;

	// test Switch values
	logic [6:0] HEX1_0,HEX1_1,HEX1_2,HEX1_3,HEX1_4,HEX1_5,HEX1_6,HEX1_7;
	logic[17:0] SW1;
	top dut1
	(
		//////////// CLOCK //////////
		.CLOCK_50(clk),
		.CLOCK2_50(),
	        .CLOCK3_50(),

		//////////// LED //////////
		.LEDG(),
		.LEDR(),

		//////////// KEY //////////
		.KEY(),

		//////////// SW //////////
		.SW(SW1),

		//////////// SEG7 //////////
		.HEX0(HEX1_0),
		.HEX1(HEX1_1),
		.HEX2(HEX1_2),
		.HEX3(HEX1_3),
		.HEX4(HEX1_4),
		.HEX5(HEX1_5),
		.HEX6(HEX1_6),
		.HEX7(HEX1_7)
	);

	logic [6:0] HEX2_0,HEX2_1,HEX2_2,HEX2_3,HEX2_4,HEX2_5,HEX2_6,HEX2_7;
	logic[17:0] SW2;
	top dut2
	(
		//////////// CLOCK //////////
		.CLOCK_50(clk),
		.CLOCK2_50(),
	        .CLOCK3_50(),

		//////////// LED //////////
		.LEDG(),
		.LEDR(),

		//////////// KEY //////////
		.KEY(),

		//////////// SW //////////
		.SW(SW2),

		//////////// SEG7 //////////
		.HEX0(HEX2_0),
		.HEX1(HEX2_1),
		.HEX2(HEX2_2),
		.HEX3(HEX2_3),
		.HEX4(HEX2_4),
		.HEX5(HEX2_5),
		.HEX6(HEX2_6),
		.HEX7(HEX2_7)
	);



	initial begin
		SW1 = {4'h0, 4'h1, 4'h2, 4'h3, 4'h4}; #10
		$display(HEX1_4);
		if (HEX1_4 !== 7'b1000000) $display("Hex Value 1-4 incorrect");
		if (HEX1_3 !== 7'b1111001) $display("Hex Value 1-3 incorrect");
		if (HEX1_2 !== 7'b0100100) $display("Hex Value 1-2 incorrect");
		if (HEX1_1 !== 7'b0110000) $display("Hex Value 1-1 incorrect");
		if (HEX1_0 !== 7'b0011001) $display("Hex Value 1-0 incorrect");

		SW2 = {4'h3, 4'h6, 4'h7, 4'h8, 4'h9}; #10
		$display(HEX2_4);
		if (HEX2_4 !== 7'b0110000) $display("Hex Value 2-4 incorrect");
		if (HEX2_3 !== 7'b0000010) $display("Hex Value 2-3 incorrect");
		if (HEX2_2 !== 7'b1111000) $display("Hex Value 2-2 incorrect");
		if (HEX2_1 !== 7'b0000000) $display("Hex Value 2-1 incorrect");
		if (HEX2_0 !== 7'b0010000) $display("Hex Value 2-0 incorrect");

                        // 4'h0: HEX = 7'b1000000;
                        // 4'h1: HEX = 7'b1111001;
                        // 4'h2: HEX = 7'b0100100;
                        // 4'h3: HEX = 7'b0110000;
                        // 4'h4: HEX = 7'b0011001;
                        // 4'h5: HEX = 7'b0010010;
                        // 4'h6: HEX = 7'b0000010;
                        // 4'h7: HEX = 7'b1111000;
                        // 4'h8: HEX = 7'b0000000;
                        // 4'h9: HEX = 7'b0010000;
                        // 4'hA: HEX = 7'b0001000;
                        // 4'hB: HEX = 7'b0000011;
                        // 4'hC: HEX = 7'b1000110;
                        // 4'hD: HEX = 7'b0100001;
                        // 4'hE: HEX = 7'b0000110;
                        // 4'hF: HEX = 7'b0001110;
		end

endmodule

