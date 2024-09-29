module DecodeStage
(
    input  logic       i_Clk,
    input  logic       i_Reset,

    // Input from Hazard Unit
    input  logic       i_StallD,
    input  logic       i_FlushD,

    // Input from Control Unit
    input  logic       i_RegWriteW,
    input  logic [1:0] i_ImmSrcD,

    // Output to Control Unit
    output logic [6:0] o_OpCode,
    output logic [2:0] o_funct3,
    output logic       o_funct7_5,

    // Input from Data Path
    input  logic [31:0] i_InstrF,
    input  logic [31:0] i_PCF,
    input  logic [31:0] i_PCPlus4F,
    input  logic [4:0]  i_RdW,
    input  logic [31:0] i_ResultW,

    // Output to Data Path
    output logic [31:0] o_RD1D, o_RD2D,
    output logic [31:0] o_PCD,
    output logic [4:0]  o_Rs1D, o_Rs2D, // Also used by Hazard Unit
    output logic [4:0]  o_RdD,
    output logic [31:0] o_ImmExtD,
    output logic [31:0] o_PCPlus4D
);

    logic [31:0] w_InstrD;

    assign o_OpCode  = w_InstrD[6:0];
    assign o_funct3  = w_InstrD[14:12];
    assign o_funct7_5 = w_InstrD[30];

    assign o_Rs1D = w_InstrD[19:15];
    assign o_Rs2D = w_InstrD[24:20];
    assign o_RdD  = w_InstrD[11:7];

    DecodeReg D_Reg
    (
        .i_Clk(i_Clk),
        .i_Reset(i_Reset),
        .i_StallD(i_StallD),
        .i_FlushD(i_FlushD),
        .i_InstrF(i_InstrF),
        .i_PCF(i_PCF),
        .i_PCPlus4F(i_PCPlus4F),
        .o_InstrD(w_InstrD),
        .o_PCD(o_PCD),
        .o_PCPlus4D(o_PCPlus4D)
    );

    RegisterFile RF 
    (
        .i_Clk(i_Clk),
        .i_Reset(i_Reset),
        .i_wEnable(i_RegWriteW),
        .i_rAddr_1(w_InstrD[19:15]),
        .i_rAddr_2(w_InstrD[24:20]),
        .i_wAddr(i_RdW),
        .i_wData(i_ResultW),
        .o_rData_1(o_RD1D),
        .o_rData_2(o_RD2D)
    );

    ExtendUnit Ext_Inst
    (
        .i_Imm(w_InstrD[31:7]),
        .i_ImmSrc(i_ImmSrcD),
        .o_ImmExt(o_ImmExtD)
    );

endmodule

