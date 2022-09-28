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
// hexdriver hex0(.val(c[3:0]), .HEX(HEX0));
// hexdriver hex1(.val(c[7:4]), .HEX(HEX1));
// hexdriver hex2(.val(c[11:8]), .HEX(HEX2));
// hexdriver hex3(.val(c[15:12]), .HEX(HEX3));
// hexdriver hex4(.val(c[19:16]), .HEX(HEX4));
// hexdriver hex5(.val(c[23:20]), .HEX(HEX5));
// hexdriver hex6(.val(c[27:24]), .HEX(HEX6));
// hexdriver hex7(.val(c[31:28]), .HEX(HEX7));

endmodule

