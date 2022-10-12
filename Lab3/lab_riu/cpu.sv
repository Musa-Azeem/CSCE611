module cpu (
    input logic clk, rst_n,
    output logic[7:0] HEX[4:0]
    )

    logic [31:0] inst_ram [4191:0];
    initial $readmemh("program.rom", inst_ram);

    logic [11:0] PC_FETH = 12'd0;
    logic [31:0] instruction_EX;

    always @(posedge clk) begin
        if (~rst_n) begin
            PC_FETCH <= 12'd0;
            instruction_EX <= 32'd0;
            end 
        else begin
            PC_FETCH <= PC_FETCH + 1'b1;
            instruction_EX <= inst_ram[PC_FETCH];
        end
    end

    
endmodule