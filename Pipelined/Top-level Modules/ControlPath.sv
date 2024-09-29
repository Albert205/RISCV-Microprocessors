module ControlPath
(
    input  logic       i_Clk,
    input  logic       i_Reset,
  
  	// Input from Hazard Unit
  	input logic		   i_FlushE,

    // Output to Hazard Unit
    output logic       o_PCSrcE,          // Also used by Data Path
    output logic       o_ResultSrcE_0,
    output logic       o_RegWriteM,
    output logic       o_RegWriteW,       // Also used by Data Path

    // Input from Data Path
    input  logic       i_ZeroE,
    input  logic [6:0] i_OpCode,
    input  logic [2:0] i_funct3,
    input  logic       i_funct7_5,

    // Output to Data Path
    output logic [1:0] o_ImmSrcD,
    output logic [2:0] o_ALUControlE,
    output logic       o_ALUSrcE,
    output logic       o_MemWriteM,
    output logic [1:0] o_ResultSrcW
);
  
  	logic       w_RegWriteD;
    logic [1:0] w_ResultSrcD;
    logic       w_MemWriteD;
    logic       w_JumpD;
    logic       w_BranchD;
    logic [2:0] w_ALUControlD;
    logic       w_ALUSrcD;
  
  	logic       w_RegWriteE;
    logic [1:0] w_ResultSrcE;
    logic       w_MemWriteE;
    logic       w_JumpE;
    logic       w_BranchE;
  
  	logic       w_RegWriteM;
    logic [1:0] w_ResultSrcM;

    ControlUnit Ctrl_Inst
    (
        .i_OpCode(i_OpCode),
        .i_funct3(i_funct3),
        .i_funct7_5(i_funct7_5),
        
        // Decode Stage Control Signals
        .o_RegWriteD(w_RegWriteD),
        .o_ResultSrcD(w_ResultSrcD),
        .o_MemWriteD(w_MemWriteD),
        .o_JumpD(w_JumpD),
        .o_BranchD(w_BranchD),
        .o_ALUControlD(w_ALUControlD),
        .o_ALUSrcD(w_ALUSrcD),

        // Output to Data Path
        .o_ImmSrcD(o_ImmSrcD)
    );

    ExecuteReg_Ctrl ExecRegC_Inst
    (
        .i_Clk(i_Clk),
        .i_Reset(i_Reset),

        // Input from Hazard Unit
        .i_FlushE(i_FlushE),
        
        // Input from Control Path
        .i_RegWriteD(w_RegWriteD),
        .i_ResultSrcD(w_ResultSrcD),
        .i_MemWriteD(w_MemWriteD),
        .i_JumpD(w_JumpD),
        .i_BranchD(w_BranchD),
        .i_ALUControlD(w_ALUControlD),
        .i_ALUSrcD(w_ALUSrcD),

        // Output to Control Path
        .o_RegWriteE(w_RegWriteE),
        .o_ResultSrcE(w_ResultSrcE),
        .o_MemWriteE(w_MemWriteE),
        .o_JumpE(w_JumpE),
        .o_BranchE(w_BranchE),

        // Output to Data Path
        .o_ALUControlE(o_ALUControlE),
        .o_ALUSrcE(o_ALUSrcE)
    );

    assign o_PCSrcE       = (i_ZeroE & w_BranchE) | (w_JumpE);      // Output to Data Path and Hazard Unit
    assign o_ResultSrcE_0 = w_ResultSrcE[0];                        // Output to Hazard Unit

    MemoryReg_Ctrl MemRegC_Inst
    (
        .i_Clk(i_Clk),
        .i_Reset(i_Reset),

        // Input from Control Path
        .i_RegWriteE(w_RegWriteE),
        .i_ResultSrcE(w_ResultSrcE),
        .i_MemWriteE(w_MemWriteE),

        // Output to Control Path
        .o_RegWriteM(w_RegWriteM),
        .o_ResultSrcM(w_ResultSrcM),

        // Output to Data Path
        .o_MemWriteM(o_MemWriteM)
    );

    assign o_RegWriteM = w_RegWriteM;           // Output to Hazard Unit (from memory stage)

    WritebackReg_Ctrl WBRegC_Inst
    (
        .i_Clk(i_Clk),
        .i_Reset(i_Reset),
        
        // Input from Control Path
        .i_RegWriteM(w_RegWriteM),
        .i_ResultSrcM(w_ResultSrcM),

        // Output to Data Path
        .o_RegWriteW(o_RegWriteW),              // Also used by Hazard Unit
        .o_ResultSrcW(o_ResultSrcW)
    );

endmodule
    