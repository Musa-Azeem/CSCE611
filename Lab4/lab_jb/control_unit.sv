module control_unit(
    input  logic        [31:0]      instr,
    input  logic        [6:0]       funct7,
    input  logic        [2:0]       funct3,
    input  logic        [6:0]       opcode,
    input  logic        [11:0]      imm12,
    input  logic                    zero,
    output logic        [3:0]       aluop,
    output logic        [1:0]       regsel, pc_src
    output logic                    alusrc, regwrite, gpio_we, stall_F
    );

    // Determine control signals

    always_comb begin
        // Initially set all to don't care
        aluop    = 4'bx;
        regsel   = 2'bx;
        alusrc   = 1'bx;
        regwrite = 1'bx;
        gpio_we  = 1'bx;
        pc_src   = 2'bx;
        stall_F  = 1'bx;

        // NO-OP - stall
        if (!instr) begin
            // Don't care about aluop, regsel, or alusrc
            regwrite = 1'b0;        // Disable write to register
            gpio_we  = 1'b0;        // Disable write to hex display
            pc_src   = 2'b00;       // Next PC is next instruction
            stall_F  = 1'b0;        // Don't stall next cycle
        end

        // IO type (csrrw) control fields
        if (opcode == 7'h73) begin
            // Don't care about aluop or alusrc - ALU not used for IO
            pc_src = 2'b00;             // Next PC is next instruction
            stall_F  = 1'b0;            // Don't stall next cycle           
            if (imm12 == 12'hf02) begin
                // If the immediate is the second IO port, we are writing to HEX
                // Don't care about regsel - not writing to registers
                regwrite = 0;           // disable write to register
                gpio_we = 1;            // enable to write to IO port
            end
            else if (imm12 == 12'hf00) begin
                // If the immediate is the first IO port, we are reading from switches
                regsel = 2'b00;         // Set to 0 to write IO port to EX/WB pipeline register
                regwrite = 1;           // Enable write to register
                gpio_we = 0;            // Disable write to IO port
            end
        end

        // U-type (lui) control fields
        else if (opcode == 7'h37) begin
            // Don't care about aluop or alusrc - ALU not used for U-type
            regsel = 2'b01;             // Set to 1 to write imm20 to EX/WB pipeline register
            regwrite = 1;               // Enable write to register
            gpio_we = 0;                // Disable write to IO
            pc_src = 2'b00;             // Next PC is next instruction
            stall_F  = 1'b0;            // Don't stall next cycle           
        end

        // R-type control fields
        else if (opcode == 7'h33) begin
            alusrc = 0;                 // Second input to ALU is value from register
            regsel = 2'b10;             // Set to 2 to write ALU output to EX/WB pipeline register
            regwrite = 1;               // Enable write to register
            gpio_we = 0;                // Disable write to IO
            pc_src = 2'b00;             // Next PC is next instruction
            stall_F  = 1'b0;            // Don't stall next cycle           

            // Get aluop based on funct7 and funct3
            case(funct7)
                7'h0: begin
                    case (funct3)
                        3'b000:     aluop = 4'b0011;        // add
                        3'b001:     aluop = 4'b1000;        // sll      (<<)
                        3'b010:     aluop = 4'b1100;        // slt      (<)
                        3'b011:     aluop = 4'b1101;        // sltu     (< unsigned)
                        3'b100:     aluop = 4'b0010;        // xor
                        3'b101:     aluop = 4'b1001;        // srl      (>>)
                        3'b110:     aluop = 4'b0001;        // or
                        3'b111:     aluop = 4'b0000;        // and
                    endcase
                end

                7'h1: begin
                    case (funct3)
                        3'b000:     aluop = 4'b0101;       // mul
                        3'b001:     aluop = 4'b0110;       // mulh
                        3'b011:     aluop = 4'b0111;       // mulhu     
                    endcase
                end

                7'h20: begin
                    case (funct3)
                        3'b000:     aluop = 4'b0100;       // sub
                        3'b101:     aluop = 4'b1010;       // sra      (>>>)
                    endcase
                end
            endcase
        end

        // I-type control fields
        else if (opcode == 7'h13) begin
            alusrc = 1;                 // Second input to ALU is sign extended imm12
            regsel = 2'b10;             // Set to 2 to write ALU output to EX/WB pipeline register
            regwrite = 1;               // Enable write to register
            gpio_we = 0;                // Disable write to IO 
            pc_src = 2'b00;             // Next PC is next instruction
            stall_F  = 1'b0;            // Don't stall next cycle           

            // Get aluop based on funct3
            case (funct3)
                3'b000:     aluop = 4'b0011;        // addi
                3'b001:     aluop = 4'b1000;        // slli 
                3'b100:     aluop = 4'b0010;        // xori
                3'b110:     aluop = 4'b0001;        // ori
                3'b111:     aluop = 4'b0000;        // andi

                // Shift instructions - choose aluop based on first 7 bits of imm12
                3'b101: begin
                    case (imm12[11:5])
                        7'h0:   aluop = 4'b1001;    // srli
                        7'h20:  aluop = 4'b1010;    // srai
                    endcase
                end
            endcase
        end

        // B-type control fields
        else if (opcode == 7'h63) begin
            // Don't care about regsel - not writing to register
            alusrc = 0;                 // Second input to ALU is value from register
            regwrite = 0;               // Disable write to register
            gpio_we = 0;                // Disable write to IO   

            case (funct3)
                3'b000:     aluop = 4'b0100;        // sub  (beq)
                3'b001:     aluop = 4'b0100;        // sub  (bne)
                3'b100:     aluop = 4'b1100;        // slt  (blt)
                3'b101:     aluop = 4'b1100;        // slt  (bge)
                3'b110:     aluop = 4'b1101;        // sltu (bltu)
                3'b111:     aluop = 4'b1101;        // sltu (bgeu)

                // Set pcsrc
                // If beq, bge, bgeu
                if (funct3 == 3'b000 || funct3 == 3'b101 || funct3 == 3'b111) begin
                    // Next PC is branch_addr if zero output of ALU is set
                    if (zero)   pc_src = 2'b01;     // Take Branch
                    else        pc_src = 2'b00;     // Don't take branch
                end
                // If bne, blt, or bltu 
                else begin
                    // Next PC is branch_addr if zero output of ALU is not set
                    if (!zero) begin
                        pc_src = 2'b01;     // Take Branch
                        stall_F  = 1'b1;    // Stall next cycle           
                    end
                    else begin
                        pc_src = 2'b00;     // Don't take branch
                        stall_F  = 1'b1;    // Stall next cycle           
                    end
                end
            endcase
        end

        // J-type (jal) control fields
        else if (opcode == 7'h6F) begin
            // Don't care about alusrc or aluop - not using ALU
            regsel = 2'b11;             // Set to 3 to write PC_EX to EX/WB pipeline register
            regwrite = 1;               // Enable write to register
            gpio_we = 0;                // Disable write to IO
            pc_src = 2'b10;             // Next PC is jal_addr
            stall_F  = 1'b1;            // Stall next cycle           
        end

        // I-type (jalr) control fields
        else if (opcode == 7'h67) begin
            // Don't care about alusrc or aluop - not using ALU
            regsel = 2'b11;             // Set to 3 to write PC_EX to EX/WB pipeline register
            regwrite = 1;               // Enable write to register
            gpio_we = 0;                // Disable write to IO
            pc_src = 2'b11;             // Next PC is jalr_addr
            stall_F  = 1'b1;            // Stall next cycle           
        end

        // do we need stall_EX?
    end

endmodule
