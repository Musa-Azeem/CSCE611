module sign_extend (
    input           [11:0]  imm12, 
    output logic    [31:0]  imm12_extended
    );
    // Sign extend immediate

    always_comb() begin
        if (imm12[11]) begin
            // If most significant bit of imm12 is 1, extend with ones
            imm12_extended = {20'b1, imm12};
        end
    end


endmodule