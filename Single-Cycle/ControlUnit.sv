/* Top-level module of the control unit */
module ControlUnit
(
    input  logic       i_Zero,
    input  logic [6:0] i_OpCode,
    input  logic [2:0] i_funct3,
    input  logic       i_funct7_5,
    output logic       o_PCSrc,
    output logic [1:0] o_ResultSrc,
    output logic       o_MemWrite,
    output logic       o_ALUSrc,
    output logic [1:0] o_ImmSrc,
    output logic       o_RegWrite,
    output logic [2:0] o_ALUControl
);

    logic [1:0] w_ALUOp;
    logic w_Branch;
    logic w_Jump;

    assign o_PCSrc = w_Jump | (i_Zero & w_Branch);

    MainDecoder MD 
    (
        .i_OpCode(i_OpCode),
        .o_Branch(w_Branch),
        .o_Jump(w_Jump),
        .o_ResultSrc(o_ResultSrc),
        .o_MemWrite(o_MemWrite),
        .o_ALUSrc(o_ALUSrc),
        .o_ImmSrc(o_ImmSrc),
        .o_RegWrite(o_RegWrite),
        .o_ALUOp(w_ALUOp)
    );

    ALUDecoder AD 
    (
        .i_OpCode_5(i_OpCode[5]),
        .i_ALUOp(w_ALUOp),
        .i_funct3(i_funct3),
        .i_funct7_5(i_funct7_5),
        .o_ALUControl(o_ALUControl)
    );

endmodule