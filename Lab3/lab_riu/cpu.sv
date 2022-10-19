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
    localparam [6:0] Rtype = 7'b0110011; 
    localparam [6:0] Itype = 7'b0010011; 
    localparam [6:0] Utype = 7'b0110111;
    // TODO localparam [6:0] Jtype =

    /*
    ---------------------------- PIPELINE STAGE 1 ----------------------------
                                     FETCH
    */
    // FETCH INSTRUCTION
    logic [11:0] PC_FETCH;
    logic [31:0] instruction_EX;
    logic [31:0] instruction_WB;

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
    logic alusrc_EX;
    logic regsel_EX;
    logic regwrite_EX;
    logic gpio_we_EX;

    // always_comb() begin
    //     case(opcode_EX)
    //         Rtype: rtype_control_fields rcf_ex( .opcode(opcode_EX),
    //                                             .aluop(aluop_EX),
    //                                             .alusrc(alusrc_EX),
    //                                             .regsel(regsel_EX),
    //                                             .regwrite(regwrite_EX),
    //                                             .gpio_we(gpio_we_EX) 
    //                                            )
    //         Itype: itype_control_fields icf_ex( .opcode(opcode_EX),
    //                                             .aluop(aluop_EX),
    //                                             .alusrc(alusrc_EX),
    //                                             .regsel(regsel_EX),
    //                                             .regwrite(regwrite_EX),
    //                                             .gpio_we(gpio_we_EX) 
    //                                            )
    //         Utype: utype_control_fields ucf_ex( .opcode(opcode_EX),
    //                                             .aluop(aluop_EX),
    //                                             .alusrc(alusrc_EX),
    //                                             .regsel(regsel_EX),
    //                                             .regwrite(regwrite_EX),
    //                                             .gpio_we(gpio_we_EX) 
    //                                            )

    //     endcase
    // end

    // EXECUTE INSTRUCTION
    // ALU with aluop and alusrc

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

module inst_decoder(
    input       [31:0]      instr,
    output      [6:0]       funct7,
    output      [2:0]       funct3,
    output      [4:0]       rs1, rs2, rd,
    output      [6:0]       opcode,
    output      [11:0]      imm12,
    output      [19:0]      imm20
    );

    // get all fields of instruction
    assign  funct7  = instr[31:25];     // R-type
    assign  rs2     = instr[24:20];     // R-type
    assign  rs1     = instr[19:15];     // R-type  I-type
    assign  funct3  = instr[14:12];     // R-type  I-type
    assign  rd      = instr[11:7];      // R-type  I-type
    assign  opcode  = instr[6:0];       // R-type  I-type
    assign  imm12   = instr[31:20];     //         I-type
    assign  imm20   = instr[31:12];     // U-type
    // TODO J-type fields
endmodule

// module rtype_control_fields(
//     input       [6:0]       funct7,
//     input       [2:0]       funct3,
//     output      [3:0]       aluop,
//     output                  alusrc, regsel, regwrite, gpio_we
//     );

//     // TODO find control signals
// endmodule

// module itype_control_fields(
//     input       [6:0]       funct7,
//     input       [2:0]       funct3,
//     output      [3:0]       aluop,
//     output                  alusrc, regsel, regwrite, gpio_we
// );

//     // TODO
// endmodule

// module utype_control_fields(
//     input       [6:0]       funct7,
//     input       [2:0]       funct3,
//     output      [3:0]       aluop,
//     output                  alusrc, regsel, regwrite, gpio_we
// );

//     // TODO
// endmodule