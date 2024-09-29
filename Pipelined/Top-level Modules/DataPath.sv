module DataPath
(
    input  logic       i_Clk,
    input  logic       i_Reset,

    // Input from Hazard Unit
    input  logic       i_StallF,
    input  logic       i_StallD,
    input  logic       i_FlushD,
    input  logic       i_FlushE,
    input  logic [1:0] i_ForwardAE, i_ForwardBE,

    // Output to Hazard Unit
    output logic [4:0] o_Rs1D, o_Rs2D,
    output logic [4:0] o_RdE,
    output logic [4:0] o_Rs1E, o_Rs2E,
    output logic [4:0] o_RdM,
    output logic [4:0] o_RdW,

    // Input from Control Path
    input  logic       i_PCSrcE,
    input  logic [1:0] i_ImmSrcD,
    input  logic       i_RegWriteW,
    input  logic [2:0] i_ALUControlE,
    input  logic       i_ALUSrcE,
    input  logic       i_MemWriteM,
    input  logic [1:0] i_ResultSrcW,

    // Output to Control Path
    output logic       o_ZeroE,
    output logic [6:0] o_OpCode,
    output logic [2:0] o_funct3,
    output logic       o_funct7_5
);

    logic [31:0] w_PCTargetE; // To be driven by the execute stage
  
  	logic [31:0] w_InstrF;
    logic [31:0] w_PCF;
    logic [31:0] w_PCPlus4F;
  
  	logic [4:0]  w_RdW;             // To be driven by the writeback stage
    logic [31:0] w_ResultW;         // To be driven by the writeback stage

    logic [31:0] w_RD1D, w_RD2D;
    logic [31:0] w_PCD;
    logic [4:0]  w_Rs1D, w_Rs2D;
    logic [4:0]  w_RdD;
    logic [31:0] w_ImmExtD;
    logic [31:0] w_PCPlus4D;

    logic [4:0]  w_RdE;
    logic [31:0] w_ALUResultE;
    logic [31:0] w_WriteDataE;
    logic [31:0] w_PCPlus4E;
  
  	logic [4:0] w_RdM;                  // Driven by memory stage
  
  	logic [31:0] w_ALUResultM;
    logic [31:0] w_ReadDataM;
    logic [31:0] w_PCPlus4M;

    FetchStage Fetch_Inst
    (
        .i_Clk(i_Clk),
        .i_Reset(i_Reset),
        
        // Input from Control Path
        .i_PCSrcE(i_PCSrcE),
        
        // Input from Hazard Unit
        .i_StallF(i_StallF),
        
        // Input from Data Path
        .i_PCTargetE(w_PCTargetE),

        // Output to Data Path
        .o_InstrF(w_InstrF),
        .o_PCF(w_PCF),
        .o_PCPlus4F(w_PCPlus4F)
    );

    DecodeStage Decode_Inst
    (
        .i_Clk(i_Clk),
        .i_Reset(i_Reset),

        // Input from Hazard Unit
        .i_StallD(i_StallD),
        .i_FlushD(i_FlushD),

        // Input from Control Path
        .i_RegWriteW(i_RegWriteW),
      	.i_ImmSrcD(i_ImmSrcD),
        
        // Output to Control Path
        .o_OpCode(o_OpCode),
        .o_funct3(o_funct3),
        .o_funct7_5(o_funct7_5),

        // Input from Data Path
        .i_InstrF(w_InstrF),
        .i_PCF(w_PCF),
        .i_PCPlus4F(w_PCPlus4F),
        .i_RdW(w_RdW),
        .i_ResultW(w_ResultW),

        // Output to Data Path
        .o_RD1D(w_RD1D),
        .o_RD2D(w_RD2D),
        .o_PCD(w_PCD),
        .o_Rs1D(w_Rs1D),
        .o_Rs2D(w_Rs2D),
        .o_RdD(w_RdD),
        .o_ImmExtD(w_ImmExtD),
        .o_PCPlus4D(w_PCPlus4D)
    );

    assign o_Rs1D = w_Rs1D;         // Output to Hazard Unit
    assign o_Rs2D = w_Rs2D;         // Output to Hazard Unit

    assign o_RdW = w_RdW;           // Output to Hazard Unit (from writeback stage)

    ExecuteStage Exec_Inst
    (
        .i_Clk(i_Clk),
       .i_Reset(i_Reset), 

       // Input from Hazard Unit
       .i_FlushE(i_FlushE),
       .i_ForwardAE(i_ForwardAE),
       .i_ForwardBE(i_ForwardBE),

       // Output to Hazard Unit
       .o_Rs1E(o_Rs1E),
       .o_Rs2E(o_Rs2E),
       .o_RdE(w_RdE),                    // Also used by Data Path

        // Input from Control Path
        .i_ALUControlE(i_ALUControlE),
        .i_ALUSrcE(i_ALUSrcE),
        
        // Output to Control Path
        .o_ZeroE(o_ZeroE),

        // Input from Data Path
        .i_RD1D(w_RD1D),
        .i_RD2D(w_RD2D),
        .i_PCD(w_PCD),
        .i_Rs1D(w_Rs1D),
        .i_Rs2D(w_Rs2D),
        .i_RdD(w_RdD),
        .i_ImmExtD(w_ImmExtD),
        .i_PCPlus4D(w_PCPlus4D),
        .i_ALUResultM(w_ALUResultM),
        .i_ResultW(w_ResultW),

        // Output to Data Path
        .o_ALUResultE(w_ALUResultE),
        .o_WriteDataE(w_WriteDataE),
        .o_PCTargetE(w_PCTargetE),
        .o_PCPlus4E(w_PCPlus4E)
    );

    assign o_RdE = w_RdE;               // Output to Hazard Unit (driven by execute stage)

    assign o_RdM = w_RdM;               // Output to Hazard Unit (driven by memory stage)

    MemoryStage Mem_Inst
    (
       .i_Clk(i_Clk),
       .i_Reset(i_Reset), 

       // Output to Hazard Unit
       .o_RdM(w_RdM),                   // Also used by Data Path

       // Input from Control Path
       .i_MemWriteM(i_MemWriteM),

       // Input from Data Path
       .i_ALUResultE(w_ALUResultE),
       .i_WriteDataE(w_WriteDataE),
       .i_RdE(w_RdE),
       .i_PCPlus4E(w_PCPlus4E),

       // Output to Data Path
       .o_ALUResultM(w_ALUResultM),
       .o_ReadDataM(w_ReadDataM),
       .o_PCPlus4M(w_PCPlus4M)
    );

    WritebackStage WB_Inst 
    (
       .i_Clk(i_Clk),
       .i_Reset(i_Reset), 

       // Output to Hazard Unit
       .o_RdW(w_RdW),                   // Also used by Data Path

       // Input from Control Path
       .i_ResultSrcW(i_ResultSrcW),

       // Input from Data Path
       .i_ALUResultM(w_ALUResultM),
       .i_ReadDataM(w_ReadDataM),
       .i_RdM(w_RdM),
       .i_PCPlus4M(w_PCPlus4M),

       // Output to Data Path
       .o_ResultW(w_ResultW)
    );

endmodule

