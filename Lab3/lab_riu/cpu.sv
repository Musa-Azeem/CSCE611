/* 
CPU module is given the clock, reset, RAM, and Swith values and outputs the 
values (in binary) to display on each of the five HEX displays
*/
module cpu (
    // Clock and Reset
    input                   clk, rst_n,

    // Switches (lower 17 bits are input from switches)
    input       [31:0]      SW,

    // Output values to display (8 4-bit fields go to each 8-segment display)
    output logic     [31:0]       display
    );

    /*
    ---------------------------- PIPELINE STAGE 1 ----------------------------
                                     FETCH
    */
	
    // READ INSTRUCTION FILE INTO RAM
	logic [31:0] inst_ram [4191:0];
    initial $readmemh("../riscv1.rom", inst_ram);

    // FETCH INSTRUCTION
    logic [11:0] PC_F = 12'b0;
    logic [31:0] instruction_EX;

    always_ff @(posedge clk) begin
        if (~rst_n) begin
            PC_F <= 12'd0;              // Reset PC to 0
            instruction_EX <= 32'd0;        // Reset executing instruction
        end 
        else begin
            // Update PC_F and instruction_EX for execution in next cycle
            PC_F <= PC_F + 1'b1;
            instruction_EX <= inst_ram[PC_F];
        end
    end

    /*
    ---------------------------- PIPELINE STAGE 2 ----------------------------
                                    DECODE
                                    EXECUTE
    */

    // DECODE INSTRUCTION

    // Fields
    logic [6:0]  funct7_EX;
    logic [4:0]  rs1_EX, rs2_EX, rd_EX;
    logic [2:0]  funct3_EX;
    logic [6:0]  opcode_EX;
    logic [11:0] imm12_EX;
    logic [19:0] imm20_EX;
    // TODO J-type

    // Decode instruction into fields
    instruction_decoder ex_decoder(
        .instr(instruction_EX), 
        // output intruction fields
        .funct7(funct7_EX),
        .funct3(funct3_EX),
        .rs1(rs1_EX),
        .rs2(rs2_EX),
        .rd(rd_EX),
        .opcode(opcode_EX),
        .imm12(imm12_EX),
        .imm20(imm20_EX)
    );

    
    // SET CONTROL SIGNALS

    logic [3:0] aluop_EX;
    logic [1:0] regsel_EX;
    logic alusrc_EX;
    logic regwrite_EX;
    logic gpio_we_EX;

    // Set control signals based on opcode and function values (and imm12 for shamt)
    control_fields cf_ex( 
        .funct7(funct7_EX),
        .funct3(funct3_EX),
        .opcode(opcode_EX),
        .imm12(imm12_EX),
        // Output control signals
        .aluop(aluop_EX),
        .alusrc(alusrc_EX),
        .regsel(regsel_EX),
        .regwrite(regwrite_EX),
        .gpio_we(gpio_we_EX) 
    );

    // READ AND WRITE REGISTER FILE
    logic [31:0] readdata1_EX;
    logic [31:0] readdata2_EX;

    // Register file instanced at end of module

    // EXTEND IMMEDIATES
    // Sign extend imm12
    logic [31:0] imm12_extented_EX;
    logic [31:0] imm20_extended_EX;

    // Replicate most significant bit of imm12 for high 20 bits  
    assign imm12_extented_EX = { {20{imm12_EX[11]}}, imm12_EX};
    // Set lower 12 bits of imm20 to 0
    assign imm20_extended_EX = { imm20_EX, 12'b0 };

    // CHOOSE SECOND ALU INPUT
    logic [31:0] B_EX;

    // set second ALU input with alusrc control mux
    assign B_EX =
        (alusrc_EX == 1'b0) ? readdata2_EX :        // If alusrc is 0, use data read from rs2
        imm12_extented_EX;                          // if alusrc is 1, use sign extended imm12

    // EXECUTE INSTRUCTION IN ALU
    logic [31:0] R_EX;
    logic alu_zero_EX;
    alu malu(   
        .A(readdata1_EX),           // First input to ALU is always data read from rs1
        .B(B_EX),                // Second input to ALU chosen by alusrc signal
        .op(aluop_EX),           // Tell ALU what operation to perform
        .R(R_EX),                // Output of ALU
        .zero()                  // Zero signal from ALU
    );

    /*
    ---------------------------- PIPELINE STAGE 3 ----------------------------
                                    WRITEBACK
    */

    // PIPELINE REGISTERS

    // Instruction fields needed for WB stage
    logic [4:0]     rd_WB;                   // Destination register to writeback to
    // logic [31:0]    imm12_extended_WB;       // imm12 for IO-type
    logic [31:0]    imm20_extended_WB;       // imm20 for U-type

    // Control fields
    logic [1:0] regsel_WB;
    logic regwrite_WB;
    logic gpio_we_WB;

    // ALU output
    logic [31:0]    R_WB;
    // data read from rs1 (for IO Output)
    logic [31:0]    readdata1_WB;

    // Update Pipeline Registers and Display output for next cycle
    always_ff @(posedge clk) begin
        rd_WB <= rd_EX;
        // imm12_extended_WB <= imm12_extented_EX;
        imm20_extended_WB <= imm20_extended_EX;
        regwrite_WB <= regwrite_EX;
        regsel_WB <= regsel_EX;
        gpio_we_WB <= gpio_we_EX;
        R_WB <= R_EX;
        readdata1_WB <= readdata1_EX;

        // IO OUTPUT
        // if csrrw instruction is writing to HEX, assign readdata1 to CPU output (otherwise, do nothing)
        if(gpio_we_WB == 1'b1) 
            display <= readdata1_WB;
        else if (~rst_n) 
            display <= 32'b0;           // Reset hex displays
        else 
            display <= display;         // Don't change
    end

    // Select value to writeback with regsel mux
    logic   [31:0]  data_WB;
    assign data_WB = 
        (regsel_WB == 2'b00) ? SW :                     // Write back switch values
        (regsel_WB == 2'b01) ? imm20_extended_WB :      // Write back U-type immediate
        R_WB;                                           // Write back the ALU output


    // REGISTER FILE
    regfile mregfile(   
        .clk(clk),
        .rst(~rst_n),
        .we(regwrite_WB),           // Pass we control signal for WB stage
        // Read data - EX stage
        .readaddr1(rs1_EX),         // Connect rs1 field from EX instr
        .readaddr2(rs2_EX),         // Connect rs2 field from EX instr
        // Write data - WB stage
        .writeaddr(rd_WB),          // Connect rd from WB instr
        .writedata(data_WB),       // Connect output of regsel mux
        // Output from read
        .readdata1(readdata1_EX),   // Data from rs1 of EX instr
        .readdata2(readdata2_EX)    // Data from rs2 of EX instr
    );

    // testing register values
    // always begin
    //     #10;
    //     // During first cycle, instruction_WB is X
    //     // $display("time: %3t: instr_wb: %8h", $time, instr_WB);
    //     #10;
    //     // second cycle, instruction_WB is 0 (from reset)
    //     // $display("time: %3t: instr_wb: %8h", $time, instr_WB);
    //     #10;
    //     // third cycle, instruction_WB is ram[0]
    //     // $display("time: %3t: instr_wb: %8h", $time, instr_WB);
	// 	if (data_WB != 8'hA) $display("instruction 0 incorrect");
    //     #10;
    //     // fourth cycle, instruction_WB is ram[1]
    //     // $display("time: %3t: instr_wb: %8h", $time, instr_WB);
    //     if (data_WB != 8'h5) $display("instruction 1 incorrect");

    //     #10;
    //     if (data_WB != 8'hF) $display("instruction 2 incorrect");

    //     #10;
	// 	if (data_WB != 8'h5) $display("instruction 3 incorrect");

    //     #10;
    //     if (data_WB != 8'h0) $display("instruction 4 incorrect");

    //     #10;
    //     if (data_WB != 8'hf) $display("instruction 5 incorrect");

    //     #10;
    //     if (data_WB != 8'hf) $display("instruction 6 incorrect");

    //     #10;
    //     if (data_WB != 8'h00000140) $display("instruction 7 incorrect");

    //     #10;
    //     if (data_WB != 8'h0) $display("instruction 8 incorrect");

    //     #10;
    //     if (data_WB != 8'h0) $display("instruction 9 incorrect");

    //     #10;
    //     if (data_WB != 8'h0) $display("instruction 10 incorrect");

    //     #10;
    //     if (data_WB != 8'h0) $display("instruction 11 incorrect");

    //     #10;
    //     if (data_WB != 8'h32) $display("instruction 12 incorrect");

    //     #10;
    //     if (data_WB != 8'h0) $display("instruction 13 incorrect");

    //     #10;
    //     if (data_WB != 8'h0) $display("instruction 14 incorrect");
    //     $finish;
    // end
endmodule
