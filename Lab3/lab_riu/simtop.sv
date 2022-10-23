/* Copyright 2020 Jason Bakos, Philip Conrad, Charles Daniels */

/* Top-level module for CSCE611 RISC-V CPU, for running under simulation.  In
 * this case, the I/Os and clock are driven by the simulator. */

module simtop;

	logic clk;
	logic 	[6:0] 		HEX0,HEX1,HEX2,HEX3,HEX4,HEX5,HEX6,HEX7;
	logic 	[17:0]		SW;
	logic	[3:0]		KEY;
	logic	[8:0]		LEDG;
	logic	[17:0]		LEDR;


	top dut
	(
		//////////// CLOCK //////////
		.CLOCK_50(clk),
		.CLOCK2_50(clk),
	    .CLOCK3_50(clk),

		//////////// LED //////////
		.LEDG(LEDG),
		.LEDR(LEDR),

		//////////// KEY //////////
		.KEY(KEY),

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

	// SIMULATE CLOCK
    always 
		#10 clk = ~clk;

	// SIMULATE INPUT
	// integer i;
	// initial begin		
	// 	SW = {2'h0, 4'h0, 4'h0, 4'h0, 4'h0};
	// 	#10
	// 	// for (i=0; i<10; i=i+1) begin
	// 	// 	$display("Simtop: %3t", $time);
	// 	// 	#10
	// 	// end
	// end

endmodule

