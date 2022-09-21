/* Copyright 2020 Jason Bakos, Philip Conrad, Charles Daniels */

/* Top-level module for CSCE611 RISC-V CPU, for running under simulation.  In
 * this case, the I/Os and clock are driven by the simulator. */

module simtop;

	logic clk;
	logic [6:0] HEX0,HEX1,HEX2,HEX3,HEX4,HEX5,HEX6,HEX7;

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
		.SW(SW),

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

// your code here

//the counter is connected to the HEX displays
hexdecoder hex0(.in(counter[3:0]), .out(HEX0));
hexdecoder hex1(.in(counter[7:4]), .out(HEX1));
hexdecoder hex2(.in(counter[11:8]), .out(HEX2));
hexdecoder hex3(.in(counter[15:12]), .out(HEX3));
hexdecoder hex4(.in(counter[19:16]), .out(HEX4));
hexdecoder hex5(.in(counter[23:20]), .out(HEX5));
hexdecoder hex6(.in(counter[27:24]), .out(HEX6));
hexdecoder hex7(.in(counter[31:28]), .out(HEX7));

endmodule

