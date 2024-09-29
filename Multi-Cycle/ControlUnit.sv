/* Top-level module of the control unit */
module ControlUnit
(
    input logic        i_Clk,
    input logic        i_Reset,
    input  logic       i_Zero,
    input  logic [6:0] i_OpCode,
    input  logic [2:0] i_funct3,
    input  logic       i_funct7_5,
    output logic       o_PCWrite,
    output logic       o_IRWrite,
    output logic       o_AdrSrc,
    output logic [1:0] o_ResultSrc,
    output logic       o_MemWrite,
    output logic [1:0] o_ALUSrcA,
    output logic [1:0] o_ALUSrcB,
    output logic [1:0] o_ImmSrc,
    output logic       o_RegWrite,
    output logic [2:0] o_ALUControl
);

    logic [1:0] w_ALUOp;
    logic w_Branch;
    logic w_PCUpdate;

    assign o_PCWrite = w_PCUpdate | (i_Zero & w_Branch);

    ControlFSM CtrlFSM_Inst
    (
        .i_Clk(i_Clk),
        .i_Reset(i_Reset),
        .i_OpCode(i_OpCode),
        .o_Branch(w_Branch),
        .o_PCUpdate(w_PCUpdate),
        .o_RegWrite(o_RegWrite),
        .o_MemWrite(o_MemWrite),
        .o_IRWrite(o_IRWrite),
        .o_ResultSrc(o_ResultSrc),
        .o_ALUSrcA(o_ALUSrcA),
        .o_ALUSrcB(o_ALUSrcB),
        .o_AdrSrc(o_AdrSrc),
      	.o_ALUOp(w_ALUOp),
        .o_State()
    );

    ALUDecoder AD_Inst 
    (
        .i_OpCode_5(i_OpCode[5]),
        .i_ALUOp(w_ALUOp),
        .i_funct3(i_funct3),
        .i_funct7_5(i_funct7_5),
        .o_ALUControl(o_ALUControl)
    );

    ImmDecoder ID_Inst
    (
        .i_OpCode(i_OpCode),
        .o_ImmSrc(o_ImmSrc)
    ); 

endmodule