module cpu (
    input logic         clk, rst_n,
    output logic[7:0]   HEX[4:0]
    )

    logic [31:0] inst_ram [4191:0];
    initial $readmemh("program.rom", inst_ram);

    logic [11:0] PC_FETH = 12'd0;
    logic [31:0] instruction_EX;

    always_ff @(posedge clk) begin
        if (~rst_n) begin
            PC_FETCH <= 12'd0;
            instruction_EX <= 32'd0;
            end 
        else begin
            PC_FETCH <= PC_FETCH + 1'b1;
            instruction_EX <= inst_ram[PC_FETCH];
        end
    end

    // decode instruction
    assign logic [6:0] funct7_EX = instruction_EX[31:25];   // R-type
    logic [4:0]  rs1_EX = instruction_EX[19:15];            // R-type  I-type
    logic [4:0]  rs2_EX = instruction_EX[24:20];            // R-type
    logic [4:0]  rd_EX = instruction_EX[11:7];              // R-type  I-type
    logic [2:0]  funct3_EX = instruction_EX[14:12];         // R-type  I-type
    logic [6:0]  opcode_EX = instruction_EX[6:0];           // R-type  I-type
    logic [11:0] imm12_EX = instruction_EX[31:20];          //         I-type
    logic [19:0] imm20_EX = instruction_EX[31:12];          // U-type
    // TODO J-type

    // check opcode to get instruction decoding type
    logic [1:0] instruction_type;
    always_comb begin
        case(opcode_EX)
            7'b0110011: instruction_type = 2'b00;    // R-type
            7'b0010011: instruction_type = 2'b01;    // I-type
            7'b0110111: instruction_type = 2'b10;    // U-type (lui)
            // TODO J-type is 3
        endcase
    end

    logic [3:0] aluop;
    logic alusrc;
    logic regsel;
    logic regwrite;
    logic gpio_we;

    // TODO set control signals with modules for R, I, and U type


endmodule