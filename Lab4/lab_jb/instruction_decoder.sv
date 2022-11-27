
module instruction_decoder(
    input       [31:0]      instr,
    input       [11:0]      PC,
    input       [31:0]      readdata1,
    output      [6:0]       funct7,
    output      [2:0]       funct3,
    output      [4:0]       rs1, rs2, rd,
    output      [6:0]       opcode,
    output      [11:0]      imm12,
    output      [19:0]      imm20,
    output      [11:0]      branch_addr,
    output      [11:0]      jal_addr,
    output      [11:0]      jalr_addr
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

    // Get branch and jump addresses
    logic [11:0] branch_offset;
    logic [11:0] jal_offset;
    logic [11:0] jalr_offset;

    assign branch_offset = {instr[31], instr[7], instr[30:25], instr[11:8], 1'b0};
    assign branch_addr   = PC + {branch_offset[12], branch_offset[12:2]};

    assign jal_offset = {instr[31], instr[19:12], instr[20], instr[30:21], 1'b0};
    assign jal_addr   = PC + jal_offset[13:2];

    assign jalr_offset = instr[31:20];
    assign jalr_addr   = readdata1 + {{2{jalr_offset[11]}},jalr_offset[11:2]};

endmodule