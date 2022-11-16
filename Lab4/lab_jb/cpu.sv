/* 
CPU module is given the clock, reset, RAM, and Swith values and outputs the 
values (in binary) to display on each of the five HEX displays
*/
module cpu (
    // Clock and Reset
    input clk, rst_n,

    // Switches (lower 17 bits are input from switches)
    input [31:0] SW,

    // Output values to display (8 4-bit fields go to each 8-segment display)
    output logic [31:0] display
    );

    // DECLARE ALL LOGIC
	logic [31:0] inst_ram [4191:0];             // Instruction Ram
    logic [11:0] PC_F;                          // PC Counter for Fetch Stage
    logic [11:0] PC_EX;                         // PC Counter for Execute stage
    logic [11:0] PC_WB;                         // PC Counter for Writeback stage
    logic [31:0] instruction_EX;                // Instruction for Execution Stage
    
    // Instruction Fields
    logic [6:0]  funct7_EX;
    logic [4:0]  rs1_EX, rs2_EX, rd_EX;
    logic [2:0]  funct3_EX;
    logic [6:0]  opcode_EX;
    logic [11:0] imm12_EX;
    logic [19:0] imm20_EX;

    // Branch/Jump Instruction Fields
    logic [11:0] branch_addr_EX;
    logic [11:0] jal_addr_EX;
    logic [11:0] jalr_addr_EX;

    // Control Signals
    logic [3:0]  aluop_EX;
    logic [1:0]  regsel_EX;
    logic        alusrc_EX;
    logic        regwrite_EX;
    logic        gpio_we_EX;
    logic [1:0]  pcsrc_EX;
    logic        stall_F;
    // logic        stall_EX;

    // Data read from register
    logic [31:0] readdata1_EX;
    logic [31:0] readdata2_EX;

    // Extended immediate fields
    logic [31:0] imm12_extented_EX;
    logic [31:0] imm20_extended_EX;

    // ALU second input
    logic [31:0] B_EX;

    // ALU output
    logic [31:0] R_EX;
    logic        alu_zero_EX;

    // Pipeline registers
    logic [4:0]  rd_WB;                     // Destination register to writeback to
    logic [31:0] imm20_extended_WB;         // imm20 for U-type
    logic [1:0]  regsel_WB;                 // Regsel to choose which value to write
    logic        regwrite_WB;               // Regwrite to choose whether to write or not
    logic        gpio_we_WB;                // gpio_we to write to Hex IO 
    logic [31:0] R_WB;                      // ALU output           
    logic [31:0] readdata1_WB;              // Data read from rs1 (for IO Output)

    // Data to write to regsiter
    logic [31:0] data_WB;


    /*
    ---------------------------- PIPELINE STAGE 1 ----------------------------
                                     FETCH
    */
	
    // READ INSTRUCTION FILE INTO RAM
    initial $readmemh("program.rom", inst_ram);
    // initial $readmemh("testbench-program.rom", inst_ram);

    // FETCH INSTRUCTION
    always_ff @(posedge clk) begin
        if (~rst_n) begin
            PC_F <= 12'd0;                  // Reset PC to 0
            instruction_EX <= 32'd0;        // Reset executing instruction
        end 
        else begin
            // Update PC_F and instruction_EX for execution in next cycle
            case (pc_src)
                1'b00:  PC_F  <= PC_F + 1'b1;
                1'b01:  PC_F  <= branch_addr_EX;
                1'b10:  PC_F  <= jal_addr_EX;
                1'b11:  PC_F  <= jalr_addr_EX;
            endcase
            PC_EX <= PC_F;

            if (stall_F)    instruction_EX <= 32'b0;
            else            instruction_EX <= inst_ram[PC_F];

            stall_EX <= stall_F;    // Update stall_EX
        end
    end

    /*
    ---------------------------- PIPELINE STAGE 2 ----------------------------
                                    DECODE
                                    EXECUTE
    */

    // DECODE INSTRUCTION
    // Decode instruction into fields
    instruction_decoder ex_decoder(
        .instr(instruction_EX), 
        .PC(PC_EX),
        // Output intruction fields
        .funct7(funct7_EX),
        .funct3(funct3_EX),
        .rs1(rs1_EX),
        .rs2(rs2_EX),
        .rd(rd_EX),
        .opcode(opcode_EX),
        .imm12(imm12_EX),
        .imm20(imm20_EX)
        .branch_addr(branch_addr_EX),
        .jal_addr(jal_addr_EX),
        .jalr_addr(jalr_addr_EX)
    );

    
    // SET CONTROL SIGNALS
    // Set control signals based on opcode and function values (and imm12 for shamt)
    control_unit cf_ex( 
        // Input required instructions fields
        .funct7(funct7_EX),
        .funct3(funct3_EX),
        .opcode(opcode_EX),
        .imm12(imm12_EX),
        .stall_EX(stall_EX),
        .zero(alu_zero_EX),
        // Output control signals
        .aluop(aluop_EX),
        .alusrc(alusrc_EX),
        .regsel(regsel_EX),
        .regwrite(regwrite_EX),
        .gpio_we(gpio_we_EX),
        .pcsrc(pcsrc_EX),
        .stall_F(stall_F)
    );

    // READ AND WRITE REGISTER FILE
    regfile mregfile(   
        .clk(clk),
        .rst(~rst_n),
        .we(regwrite_WB),           // Pass we control signal for WB stage
        // Read data - EX stage
        .readaddr1(rs1_EX),         // Connect rs1 field from EX instr
        .readaddr2(rs2_EX),         // Connect rs2 field from EX instr
        // Write data - WB stage
        .writeaddr(rd_WB),          // Connect rd from WB instr
        .writedata(data_WB),        // Connect output of regsel mux
        // Output from read
        .readdata1(readdata1_EX),   // Data from rs1 of EX instr
        .readdata2(readdata2_EX)    // Data from rs2 of EX instr
    );

    // EXTEND IMMEDIATES
    // Replicate most significant bit of imm12 for high 20 bits  
    assign imm12_extented_EX = { {20{imm12_EX[11]}}, imm12_EX};
    // Set lower 12 bits of imm20 to 0
    assign imm20_extended_EX = { imm20_EX, 12'b0 };

    // CHOOSE SECOND ALU INPUT
    // set second ALU input with alusrc control mux
    assign B_EX =
        (alusrc_EX == 1'b0) ? readdata2_EX :        // If alusrc is 0, use data read from rs2
        imm12_extented_EX;                          // if alusrc is 1, use sign extended imm12

    // EXECUTE INSTRUCTION IN ALU
    alu malu(   
        .A(readdata1_EX),           // First input to ALU is always data read from rs1
        .B(B_EX),                   // Second input to ALU chosen by alusrc signal
        .op(aluop_EX),              // Tell ALU what operation to perform
        .R(R_EX),                   // Output of ALU
        .zero(alu_zero_EX)          // Zero signal from ALU
    );

    /*
    ---------------------------- PIPELINE STAGE 3 ----------------------------
                                    WRITEBACK
    */

    // UPDATE PIPELINE REGISTERS
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
    assign data_WB = 
        (regsel_WB == 2'b00) ? SW :                     // Write back switch values
        (regsel_WB == 2'b01) ? imm20_extended_WB :      // Write back U-type immediate
        (regsel_WB == 2'b10) ? R_WB:                    // Write back the ALU output
        PC_EX;                                          // Write back the current PC

    // WRITE TO REGISTER
    // In register file above

endmodule
