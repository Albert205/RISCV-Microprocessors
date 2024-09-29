module ExecuteReg_Ctrl
(
    input  logic        i_Clk,
    input  logic        i_Reset,

    // Hazard Unit Input
    input  logic        i_FlushE,

    // Input from Control Path
    input  logic        i_RegWriteD,
    input  logic [1:0]  i_ResultSrcD,
    input  logic        i_MemWriteD,
    input  logic        i_JumpD,
    input  logic        i_BranchD,
    input  logic [2:0]  i_ALUControlD,
    input  logic        i_ALUSrcD,

    // Output to Control Path
    output logic        o_RegWriteE,
    output logic [1:0]  o_ResultSrcE,
    output logic        o_MemWriteE,
    output logic        o_JumpE,
    output logic        o_BranchE,
    output logic [2:0]  o_ALUControlE,
    output logic        o_ALUSrcE
);

    // Control Path Register
    always_ff @(posedge i_Clk or negedge i_Reset)
        if(~i_Reset | i_FlushE)                    // Reset or flush clears the register
        begin
            o_RegWriteE   <= 0;
            o_ResultSrcE  <= 0;
            o_MemWriteE   <= 0;
            o_JumpE       <= 0;
            o_BranchE     <= 0;
            o_ALUControlE <= 0;
            o_ALUSrcE     <= 0;
        end
        else
        begin
            o_RegWriteE   <= i_RegWriteD;
            o_ResultSrcE  <= i_ResultSrcD;
            o_MemWriteE   <= i_MemWriteD;
            o_JumpE       <= i_JumpD;
            o_BranchE     <= i_BranchD;
            o_ALUControlE <= i_ALUControlD;
            o_ALUSrcE     <= i_ALUSrcD;
        end
endmodule