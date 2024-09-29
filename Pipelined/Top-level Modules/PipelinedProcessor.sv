module PipelinedProcessor
(
    input logic i_Clk,
    input logic i_Reset
);

    // Inputs from Control Path to Hazard Unit
    logic       w_PCSrcE;           // Also used by Data Path
    logic       w_ResultSrcE_0;
    logic       w_RegWriteM;
    logic       w_RegWriteW;        // Also used by Data Path       

    // Inputs from Data Path to Hazard Unit
    logic [4:0] w_Rs1D, w_Rs2D;
    logic [4:0] w_Rs1E, w_Rs2E;
    logic [4:0] w_RdE;
    logic [4:0] w_RdM;
    logic [4:0] w_RdW;

    // Outputs from Hazard Unit to Data Path
    logic       w_StallF;
    logic       w_StallD;
    logic       w_FlushD;
    logic       w_FlushE;
    logic [1:0] w_ForwardAE, w_ForwardBE;

    // Inputs from Data Path to Control Path
    logic       w_ZeroE;
    logic [6:0] w_OpCode;
    logic [2:0] w_funct3;
    logic       w_funct7_5;

    // Inputs from Control Path to Data Path
    logic [1:0] w_ImmSrcD;
    logic [2:0] w_ALUControlE;
    logic       w_ALUSrcE;
    logic       w_MemWriteM;
    logic [1:0] w_ResultSrcW;

    ControlPath CP_Inst 
    (
        .i_Clk(i_Clk),
        .i_Reset(i_Reset),

        // Outputs to Hazard Unit
        .o_PCSrcE(w_PCSrcE),
        .o_ResultSrcE_0(w_ResultSrcE_0),
        .o_RegWriteM(w_RegWriteM),
        .o_RegWriteW(w_RegWriteW),

        // Inputs from Data Path
        .i_ZeroE(w_ZeroE),
        .i_OpCode(w_OpCode),
        .i_funct3(w_funct3),
        .i_funct7_5(w_funct7_5),
        
        // Outputs to Data Path
        .o_ImmSrcD(w_ImmSrcD),
        .o_RegWriteW(w_RegWriteW),
        .o_ALUControlE(w_ALUControlE),
        .o_ALUSrcE(w_ALUSrcE),
        .o_MemWriteM(w_MemWriteM),
        .o_ResultSrcW(w_ResultSrcW)
    );

    DataPath DP_Inst
    (
        .i_Clk(i_Clk),
        .i_Reset(i_Reset),

        // Inputs from Hazard Unit
        .i_StallF(w_StallF),
        .i_StallD(w_StallD),
        .i_FlushD(w_FlushD),
        .i_FlushE(w_FlushE),
        .i_ForwardAE(w_ForwardAE),
        .i_ForwardBE(w_ForwardBE),

        // Outputs to Hazard Unit
        .o_Rs1D(w_Rs1D),
        .o_Rs2D(w_Rs2D),
        .o_RdE(w_RdE),
        .o_Rs1E(w_Rs1E),
        .o_Rs2E(w_Rs2E),
        .o_RdM(w_RdM),
        .o_RdW(w_RdW),
        
        // Input from Control Path
        .i_PCSrcE(w_PCSrcE),
        .i_ImmSrcD(w_ImmSrcD),
        .i_RegWriteW(w_RegWriteW),
        .i_ALUControlE(w_ALUControlE),
        .i_ALUSrcE(w_ALUSrcE),
        .i_MemWriteM(w_MemWriteM),
        .i_ResultSrcW(w_ResultSrcW),

        // Output to Control Path
        .o_ZeroE(w_ZeroE),
        .o_OpCode(w_OpCode),
        .o_funct3(w_funct3),
        .o_funct7_5(w_funct7_5)
    );

    HazardUnit HU_Inst
    (
        // Inputs from Data Path
        .i_Rs1D(w_Rs1D),
        .i_Rs2D(w_Rs2D),
        .i_Rs1E(w_Rs1E),
        .i_Rs2E(w_Rs2E),
        .i_RdE(w_RdE),
        .i_RdM(w_RdM),
        .i_RdW(w_RdW),

        // Inputs from Control Path
        .i_PCSrcE(w_PCSrcE),
        .i_ResultSrcE_0(w_ResultSrcE_0),
        .i_RegWriteM(w_RegWriteM),
        .i_RegWriteW(w_RegWriteW),

        // Outputs to Data Path
        .o_StallF(w_StallF),
        .o_StallD(w_StallD),
        .o_FlushD(w_FlushD),
        .o_FlushE(w_FlushE),
        .o_ForwardAE(w_ForwardAE),
        .o_ForwardBE(w_ForwardBE)
    );

endmodule