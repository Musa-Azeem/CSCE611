/* 
CPU module is given the clock, reset, RAM, and Swith values and outputs the 
values (in binary) to display on each of the five HEX displays
*/
module cpu (
    // Clock and Reset
    input                   clk, rst_n,

    // RAM
    input       [31:0]      inst_ram [4191:0],

    // Switches
    input       [17:0]      SW,

    // Output values to display
    output      [3:0]       hex0, hex1, hex2, hex3, hex4
    );

    // opcode values for each type of instruction

    /*
    ---------------------------- PIPELINE STAGE 1 ----------------------------
                                     FETCH
    */
    // FETCH INSTRUCTION
    logic [11:0] PC_FETCH;
    logic [31:0] instruction_EX;
    logic [31:0] instruction_WB;

	assign PC_FETCH = 12'd0;

    always_ff @(posedge clk) begin
        if (~rst_n) begin
            PC_FETCH <= 12'd0;
            instruction_EX <= 32'd0;
        end 
        else begin
            // Update PC_FETCH and instruction_EX for execution in next cycle
            PC_FETCH <= PC_FETCH + 1'b1;
            instruction_EX <= inst_ram[PC_FETCH];
            // Update instruction_WB with the current instruction_EX
            instruction_WB <= instruction_EX;
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
        .funct7(funct7_EX),
        .funct3(funct3_EX),
        .rs1(rs1_EX),
        .rs2(rs2_EX),
        .rd(rd_EX),
        .opcode(opcode_EX),
        .imm12(imm12_EX),
        .imm20(imm20_EX));
    
    // Set control signals based on opcode and function values

    logic [3:0] aluop_EX;
    logic [1:0] regsel_EX;
    logic alusrc_EX;
    logic regwrite_EX;
    logic gpio_we_EX;

    control_fields cf_ex( .funct7(funct7_EX),
                          .funct3(funct3_EX),
                          .opcode(opcode_EX),
                          .imm12(imm12_EX),
                          .aluop(aluop_EX),
                          .alusrc(alusrc_EX),
                          .regsel(regsel_EX),
                          .regwrite(regwrite_EX),
                          .gpio_we(gpio_we_EX) 
                        )

    // EXECUTE INSTRUCTION
    // read regsiter file (write wb)
    // sign extend imm12
    // wire ALU with aluop and alusrc and reg or imm12
    // Save output of ALU, imm20, or IO to EX/WB pipeline register (32 bit variable)
    

    /*
    ---------------------------- PIPELINE STAGE 3 ----------------------------
                                    WRITEBACK
    */

    // if csrrw instruction, read from SW or write to HEX
    assign hex0 = 0;
    assign hex1 = 1;
    assign hex2 = 2;
    assign hex3 = 3;
    assign hex4 = 4;
endmodule
