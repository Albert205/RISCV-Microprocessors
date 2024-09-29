module MemoryStage
(
    input  logic        i_Clk,
    input  logic        i_Reset,

    // Output to Hazard Unit
    output logic [4:0]  o_RdM,           // Also used by Data Path

    // Input from Control Path
    input  logic        i_MemWriteM,

    // Input from Data Path
    input  logic [31:0] i_ALUResultE,
    input  logic [31:0] i_WriteDataE,
    input  logic [4:0]  i_RdE,
    input  logic [31:0] i_PCPlus4E,

    // Data Path Output
    output logic [31:0] o_ALUResultM,
    output logic [31:0] o_ReadDataM,
    output logic [31:0] o_PCPlus4M
);

    logic [31:0] w_ALUResultM;
    logic [31:0] w_WriteDataM;

    MemoryReg_Data MemRegD_Inst
    (
        .i_Clk(i_Clk),
        .i_Reset(i_Reset),
        .i_ALUResultE(i_ALUResultE),
        .i_WriteDataE(i_WriteDataE),
        .i_RdE(i_RdE),
        .i_PCPlus4E(i_PCPlus4E),
        .o_ALUResultM(w_ALUResultM),
        .o_WriteDataM(w_WriteDataM),
        .o_RdM(o_RdM),
        .o_PCPlus4M(o_PCPlus4M)
    );

    DataMemory DM 
    (
        .i_Clk(i_Clk),
        .i_Reset(i_Reset),
        .i_wEnable(i_MemWriteM),
        .i_Addr(w_ALUResultM),
        .i_wData(w_WriteDataM),
        .o_rData(o_ReadDataM)
    );

endmodule