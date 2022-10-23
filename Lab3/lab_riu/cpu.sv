/* 
CPU module is given the clock, reset, RAM, and Swith values and outputs the 
values (in binary) to display on each of the five HEX displays
*/
module cpu (
    // Clock and Reset
    input                   clk, rst_n,

    // RAM
    input       [31:0]      inst_ram [4191:0],

    // Switches (lower 17 bits are input from switches)
    input       [31:0]      SW,

    // Output values to display (lower 20 bits are the 5 4-bit decimal values to display)
    output      [31:0]       display
    );

    // opcode values for each type of instruction

    /*
    ---------------------------- PIPELINE STAGE 1 ----------------------------
                                     FETCH
    */

    // FETCH INSTRUCTION
    logic [11:0] PC_FETCH;
    logic [31:0] instruction_EX;

    always_ff @(posedge clk) begin
        if (~rst_n) begin
            PC_FETCH <= 12'd0;
            instruction_EX <= 32'd0;
        end 
        else begin
            // Update PC_FETCH and instruction_EX for execution in next cycle
            PC_FETCH <= PC_FETCH + 1'b1;
            instruction_EX <= inst_ram[PC_FETCH];
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
    inst_decoder ex_decoder(
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
        (alusrc_EX == 1'b0) ? readdata1_EX :        // If alusrc is 0, use data read from rs2
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
    logic [31:0]    imm12_extended_WB;       // imm12 for IO-type
    logic [31:0]    imm20_extended_WB;       // imm20 for U-type

    // Control fields
    logic regwrite_WB;
    logic regsel_WB;
    logic gpio_we_WB;

    // ALU output
    logic [31:0]    R_WB;

    // Update Pipeline Registers for next cycle
    always_ff @(posedge clk) begin
        rd_WB <= rd_EX;
        imm12_extended_WB <= imm12_extented_EX;
        imm20_extended_WB <= imm20_extended_EX;
        regwrite_WB <= regwrite_EX;
        regsel_WB <= regsel_EX;
        gpio_we_WB <= gpio_we_EX;
        R_WB <= R_EX;
    end

    // Select value to writeback with regsel mux
    logic   [31:0]  data_WB;
    assign data_WB = 
        (regsel_WB == 2'b00) ? SW :                     // Write back switch values
        (regsel_WB == 2'b01) ? imm20_extended_WB :      // Write back U-type immediate
        R_WB;                                           // Write back the ALU output

    // IO OUTPUT
    // if csrrw instruction is writing to HEX, assign readdata1 to CPU output (otherwise, do nothing)
    assign display = 
        (gpio_we_WB == 1'b1) ? readdata1_EX : display;


    regfile mregfile(   
        .clk(clk),
        .rst(rst_n),
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

    initial begin
        $display("$cpu.sv @ %3t: Fetch : %3h", $time, PC_FETCH);
        $display("$cpu.sv @ %3t: instr_ex : %8h", $time, instruction_EX);
        $display("$cpu.sv @ %3t: funct7_ex : %7b", $time, funct7_EX);
        $display("$cpu.sv @ %3t: funct3_ex : %3b", $time, funct3_EX);
        $display("$cpu.sv @ %3t: rs1_ex : %5b", $time, rs1_EX);
        $display("$cpu.sv @ %3t: rs2_ex : %5b", $time, rs2_EX);
        $display("$cpu.sv @ %3t: rd_ex : %5b", $time, rd_EX);
        $display("$cpu.sv @ %3t: opcode_ex : %7b", $time, opcode_EX);
        $display("$cpu.sv @ %3t: imm12_ex : %12b", $time, imm12_EX);
        $display("$cpu.sv @ %3t: imm20_ex : %20b", $time, imm20_EX);
    end
endmodule
