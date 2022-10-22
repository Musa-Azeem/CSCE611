
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