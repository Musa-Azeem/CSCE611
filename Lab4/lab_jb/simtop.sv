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
	initial begin
		#100;
	end
	// initial begin	
	// 	SW = {2'h0, 4'h0, 4'h0, 4'h0, 4'h1};
	// 	KEY = 4'b0;		// reset

	// 	#10;
	// 	KEY = 4'b1;

	// 	#10;
	// 	#10;
	// 	#10;
	// 	if (dut.mcpu.mregfile.mem[1] != expected_values[0]) $display("Test case 0 incorrect");
	// 	#10;
	// 	if (dut.mcpu.mregfile.mem[2] != expected_values[1]) $display("Test case 1 incorrect");
	// 	#10;
	// 	if (dut.mcpu.mregfile.mem[3] != expected_values[2]) $display("Test case 2 incorrect");
	// 	#10;
	// 	if (dut.mcpu.mregfile.mem[3] != expected_values[3]) $display("Test case 3 incorrect");
	// 	#10;
	// 	if (dut.mcpu.mregfile.mem[3] != expected_values[4]) $display("Test case 4 incorrect");
	// 	#10;
	// 	if (dut.mcpu.mregfile.mem[4] != expected_values[5]) $display("Test case 5 incorrect");
	// 	#10;
	// 	if (dut.mcpu.mregfile.mem[4] != expected_values[6]) $display("Test case 6 incorrect");
	// 	#10;
	// 	if (dut.mcpu.mregfile.mem[5] != expected_values[7]) $display("Test case 7 incorrect");
	// 	#10;
	// 	if (dut.mcpu.mregfile.mem[6] != expected_values[8]) $display("Test case 8 incorrect");
	// 	#10;
	// 	if (dut.mcpu.mregfile.mem[6] != expected_values[9]) $display("Test case 9 incorrect");
	// 	#10;

	// 	for (i=7; i<20; i=i+1) begin
	// 		if (dut.mcpu.mregfile.mem[i] != expected_values[i+3]) $display("Test case %i incorrect", (i+3));
	// 		#10;
	// 	end

	// 	if (dut.display != expected_values[24]) $display("Test case 24 incorrect");
	// 	if (dut.mcpu.mregfile.mem[21] != expected_values[25]) $display("Test case 25 incorrect");
	// end

	always_ff @(posedge clk) begin
		$display(dut.mcpu.PC_F);
	end

endmodule

