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
        .imm20(imm20_EX));

    
    // SET CONTROL SIGNALS

    logic [3:0] aluop_EX;
    logic [1:0] regsel_EX;
    logic alusrc_EX;
    logic regwrite_EX;
    logic gpio_we_EX;

    // Set control signals based on opcode and function values (and imm12 for shamt)
    control_fields cf_ex( .funct7(funct7_EX),
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

    registers regfile(  .clk(clk),
                        .rst(rst),
                        .we(regwrite_WB),           // Pass we control signal for WB stage
                        // Read data - EX stage
                        .readaddr1(rs1_EX),         // Connect rs1 field from EX instr
                        .readaddr2(rs2_EX),         // Connect rs2 field from EX instr
                        // Write data - WB stage
                        .writeaddr(rd_WB),          // Connect rd from WB instr
                        .writedata(/*TODO*/),       // Connect output of regsel mux
                        // Output from read
                        .readdata1(readdata1_EX),   // Data from rs1 of EX instr
                        .readdata2(readdata2_EX)    // Data from rs2 of EX instr
                        );

    // EXTEND IMMEDIATES
    // Sign extend imm12
    logic [31:0] imm12_extented_EX;
    logic [31:0] imm20_extended_EX;

    // Replicate most significant bit of imm12 for high 20 bits  
    assign imm12_extented_EX = { {20{imm_EX[11]}}, imm12_EX};
    // Set lower 12 bits of imm20 to 0
    assign imm20_extended_EX = { imm20_EX, 12'b0 };
    
    // EXECUTE INSTRUCTION

    // Get the two 
    // read regsiter file (write wb)
    // sign extend imm12

    // wire ALU with aluop and alusrc and reg or imm12
    // Save output of ALU, imm20, or IO to EX/WB pipeline register (32 bit variable)
    

    /*
    ---------------------------- PIPELINE STAGE 3 ----------------------------
                                    WRITEBACK
    */

    // PIPELINE REGISTERS

    // Instruction fields needed for WB stage
    logic [4:0]     rd_wb;          // register to writeback to
    logic [31:0]    imm12_extended_WB;       // imm12 for IO-type
    logic [31:0]    imm20_extended_WB;       // imm20 for U-type

    // Control fields

    // Intermeditate steps


    // ALU output

    always_ff @posedge(clk) begin
        // Update the fields / control signals needed for the WB stage
        regsel_WB <= regsel_EX;

    end

    // if csrrw instruction, read from SW or write to HEX


    
    assign hex0 = 0;
    assign hex1 = 1;
    assign hex2 = 2;
    assign hex3 = 3;
    assign hex4 = 4;
endmodule
