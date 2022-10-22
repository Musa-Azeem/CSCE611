module control_fields(
    input               [6:0]       funct7,
    input               [2:0]       funct3,
    input               [6:0]       opcode,
    input               [11:0]      imm12,
    output logic        [3:0]       aluop,
    output logic        [1:0]       regsel,
    output logic                    alusrc, regwrite, gpio_we
    );

    // Find control signals

    always_comb begin
        // First, IO type (csrrw) control fields
        if (opcode == 7'h73 && funct3 == 3'b001) begin
            // Don't set aluop or alusrc - ALU not used for IO
            if (imm12 == 12'hf02) begin
                // If the immediate is the second IO port, we are writing to HEX
                // Don't set regsel - not writing to registers
                regwrite = 0;           // disable write to register
                gpio_we = 1;            // enable to write to IO port
            end
            else if (imm12 == 7'hf00) begin
                // If the immediate is the first IO port, we are reading from switches
                regsel = 2'b00;         // Set to 0 to read IO port to EX/WB pipeline register
                regwrite = 1;           // Enable write to register
                gpio_we = 0;            // Disable write to IO port
            end
        end

        // Next, U-type (lui) control fields
        else if (opcode == 7'h37) begin
            // Don't set aluop or alusrc - ALU not used for U-type
            regsel = 2'b01;             // Set to 1 to read imm20 to EX/WB pipeline register
            regwrite = 1;               // Enable write to register
            gpio_we = 0;                // Disable write to IO
        end

        // Next, R-type control fields
        else if (opcode == 7'h33) begin
            alusrc = 0;                 // Second input to ALU is value from register
            regsel = 2'b10;             // Set to 2 to read ALU output to EX/WB pipeline register
            regwrite = 1;               // Enable write to register
            gpio_we = 0;                // Disable write to IO

            // Get aluop based on funct7 and funct3
            case(funct7)
                7'h0: begin
                    case (funct3)
                        3'b000:     aluop = 0011;       // add
                        3'b001:     aluop = 1000;       // sll      (<<)
                        3'b010:     aluop = 1100;       // slt      (<)
                        3'b011:     aluop = 1101;       // sltu     (< unsigned)
                        3'b100:     aluop = 0010;       // xor
                        3'b101:     aluop = 1001;       // srl      (>>)
                        3'b110:     aluop = 0001;       // or
                        3'b111:     aluop = 0000;       // and
                    endcase
                end

                7'h1: begin
                    case (funct3)
                        3'b000:     aluop = 0101;       // mul
                        3'b001:     aluop = 0110;       // mulh
                        3'b011:     aluop = 0111;       // mulhu     
                    endcase
                end

                7'h20: begin
                    case (funct3)
                        3'b000:     aluop = 0100;       // sub
                        3'b101:     aluop = 1010;       // sra      (>>>)
                    endcase
                end

            endcase
        end

        // Next I-type control fields (excluding aluop)
        else if (opcode == 7'h13) begin
            alusrc = 1;                 // Second input to ALU is sign extended imm12
            regsel = 2'b10;             // Set to 2 to read ALU output to EX/WB pipeline register
            regwrite = 1;               // Enable write to register
            gpio_we = 0;                // Disable write to IO   

            // Get aluop based on funct3
            case (funct3)
                3'b000:     aluop = 0011;       // addi
                3'b001:     aluop = 1000;       // slli 
                3'b100:     aluop = 0010;       // xori
                3'b110:     aluop = 0001;       // ori
                3'b111:     aluop = 0000;       // andi

                // Shift instructions - choose aluop based on first 7 bits of imm12
                3'b101: begin
                    case (imm12[11:5])
                        7'h0:   aluop = 1001;   // srli
                        7'h20:  aluop = 1010;   // srai
                    endcase
                end
            endcase
        end
    end

endmodule
