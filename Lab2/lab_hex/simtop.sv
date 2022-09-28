/* Copyright 2020 Jason Bakos, Philip Conrad, Charles Daniels */

/* Top-level module for CSCE611 RISC-V CPU, for running under simulation.  In
 * this case, the I/Os and clock are driven by the simulator. */

module simtop;

	logic clk;
	logic [6:0] HEX0,HEX1,HEX2,HEX3,HEX4,HEX5,HEX6,HEX7;

	// test Switch values
	logic SW1[17:0];
	assign SW1[17:16] = 2'h3;
	assign SW1[15:12] = 4'hF;
	assign SW1[11:8] = 4'hE;
	assign SW1[7:4] = 4'hD;
	assign SW1[3:0] = 4'hC;

	top dut
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
		.HEX0(HEX0),
		.HEX1(HEX1),
		.HEX2(HEX2),
		.HEX3(HEX3),
		.HEX4(HEX4),
		.HEX5(HEX5),
		.HEX6(HEX6),
		.HEX7(HEX7)
	);



	// initial begin

	// 	a = 1'b0; b = 1'b0; c = 1'b0; #10;
	// 	if (y !== 1'b1) $display("000 failed.");
	// 	c = 1’b1; #10;
	// 	if (y !== 1’b0) $display("001 failed.");
	// 	b = 1’b1; c = 1’b0; #10;
	// 	if (y !== 1’b0) $display("010 failed.");
	// 	c = 1’b1; #10;
	// 	if (y !== 0) $display("011 failed.");
	// 	a = 1’b1; b = 1’b0; c = 1’b0; #10;
	// 	if (y !== 1’b1) $display("100 failed.");
	// 	c = 1’b1; #10;
	// 	if (y !== 1) $display("101 failed.");
	// 	b = 1’b1; c = 1’b0; #10;
	// 	if (y !== 1’b0) $display("110 failed.");
	// 	c = 1’b1; #10;
	// 	if (y !== 1’b0) $display("111 failed.");
	// 	end

endmodule

