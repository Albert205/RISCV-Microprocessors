/* Top-level module of the control unit */
module ControlUnit
(
    input  logic [6:0] i_OpCode,
    input  logic [2:0] i_funct3,
    input  logic       i_funct7_5,

    /* Decode stage control signals */
    output logic o_RegWriteD,
    output logic [1:0] o_ResultSrcD,
    output logic o_MemWriteD,
    output logic o_JumpD,
    output logic o_BranchD,
    output logic [2:0] o_ALUControlD,
    output logic o_ALUSrcD,
    output logic [1:0] o_ImmSrcD
);

    logic [1:0] w_ALUOp;

    MainDecoder MD 
    (
        .i_OpCode(i_OpCode),
        .o_Branch(o_BranchD),
        .o_Jump(o_JumpD),
        .o_ResultSrc(o_ResultSrcD),
        .o_MemWrite(o_MemWriteD),
        .o_ALUSrc(o_ALUSrcD),
        .o_ImmSrc(o_ImmSrcD),
        .o_RegWrite(o_RegWriteD),
        .o_ALUOp(w_ALUOp)
    );

    ALUDecoder AD 
    (
        .i_OpCode_5(i_OpCode[5]),
        .i_ALUOp(w_ALUOp),
        .i_funct3(i_funct3),
        .i_funct7_5(i_funct7_5),
        .o_ALUControl(o_ALUControlD)
    );

endmodule