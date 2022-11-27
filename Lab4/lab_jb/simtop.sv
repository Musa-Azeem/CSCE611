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
    always begin
		#5 clk = 1;
		#5 clk = 0;
	end

	// Read expected values
	logic [11:0] expected_values [4191:0];
    initial $readmemh("testbench-expected-pc.rom", expected_values);

	// SIMULATE INPUT
	integer i;
	initial begin
		SW = {2'h0, 4'h0, 4'h0, 4'h0, 4'h0};
		KEY = 4'b0;		// reset

		#10;
		KEY = 4'b1;
		
		for (int i=0; i<17; i++) begin
			if (dut.mcpu.PC_F != expected_values[i]) begin
				$display("Intruction $d failed at PC_F = %3h", i, dut.mcpu.PC_F);
			end
			#10;
		end
	end

endmodule

