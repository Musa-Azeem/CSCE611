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
		// .SW(SW),

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
logic [31:0] c;  //initialize counter 
initial begin
	c = 0;
end

//the counter is connected to the HEX displays
hexdriver hex0(.in(c[3:0]), .out(HEX0));
hexdriver hex1(.in(c[7:4]), .out(HEX1));
hexdriver hex2(.in(c[11:8]), .out(HEX2));
hexdriver hex3(.in(c[15:12]), .out(HEX3));
hexdriver hex4(.in(c[19:16]), .out(HEX4));
hexdriver hex5(.in(c[23:20]), .out(HEX5));
hexdriver hex6(.in(c[27:24]), .out(HEX6));
hexdriver hex7(.in(c[31:28]), .out(HEX7));

endmodule

