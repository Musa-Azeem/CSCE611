/* Copyright 2020 Jason Bakos, Philip Conrad, Charles Daniels */

/* Top-level module for CSCE611 RISC-V CPU, for running under simulation.  In
 * this case, the I/Os and clock are driven by the simulator. */

module simtop;

	logic clk;
	logic 	[6:0] 		HEX0,HEX1,HEX2,HEX3,HEX4,HEX5,HEX6,HEX7;
	logic 	[17:0]		SW;

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
    always
        begin
            #5 clk = 1;
            #5 clk = 0;
        end
// your code here
//	initial begin		
//		SW = {2'h0, 4'h1, 4'h2, 4'h3, 4'h4}; #10
//		if (HEX4 !== 7'b1000000) $display("Hex Value 1-4 incorrect");
//		if (HEX3 !== 7'b1111001) $display("Hex Value 1-3 incorrect");
//		if (HEX2 !== 7'b0100100) $display("Hex Value 1-2 incorrect");
//		if (HEX1 !== 7'b0110000) $display("Hex Value 1-1 incorrect");
//		if (HEX0 !== 7'b0011001) $display("Hex Value 1-0 incorrect");

//		SW = {2'h3, 4'h6, 4'h7, 4'h8, 4'h9}; #10
//		if (HEX4 !== 7'b0110000) $display("Hex Value 2-4 incorrect");
//		if (HEX3 !== 7'b0000010) $display("Hex Value 2-3 incorrect");
//		if (HEX2 !== 7'b1111000) $display("Hex Value 2-2 incorrect");
//		if (HEX1 !== 7'b0000000) $display("Hex Value 2-1 incorrect");
//		if (HEX0 !== 7'b0010000) $display("Hex Value 2-0 incorrect");
//	end

endmodule

