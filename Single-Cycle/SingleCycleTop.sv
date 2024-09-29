/* Top-level module of the single-cycle processor */

module SingleCycleTop
(
    input logic i_Clk,
    input logic i_Reset
);

    logic w_Zero;
    logic [6:0] w_OpCode;
    logic [2:0] w_funct3;
    logic w_funct7_5;
    logic w_PCSrc;
    logic[1:0] w_ResultSrc;
    logic w_MemWrite;
    logic w_ALUSrc;
    logic [1:0] w_ImmSrc;
    logic w_RegWrite;
    logic [2:0] w_ALUControl;

    ControlUnit Ctrl_Inst
    (
        .i_Zero(w_Zero),
        .i_OpCode(w_OpCode),
        .i_funct3(w_funct3),
        .i_funct7_5(w_funct7_5),
        .o_PCSrc(w_PCSrc),
        .o_ResultSrc(w_ResultSrc),
        .o_MemWrite(w_MemWrite),
        .o_ALUSrc(w_ALUSrc),
        .o_ImmSrc(w_ImmSrc),
        .o_RegWrite(w_RegWrite),
        .o_ALUControl(w_ALUControl)
    );

    DataPath Data_Inst
    (
       .i_Clk(i_Clk),
       .i_Reset(i_Reset),
       .i_PCSrc(w_PCSrc),
       .i_ResultSrc(w_ResultSrc),
       .i_MemWrite(w_MemWrite),
       .i_ALUSrc(w_ALUSrc),
       .i_ImmSrc(w_ImmSrc),
       .i_RegWrite(w_RegWrite),
       .i_ALUControl(w_ALUControl),
       .o_Zero(w_Zero),
       .o_OpCode(w_OpCode),
       .o_funct3(w_funct3),
       .o_funct7_5(w_funct7_5) 
    );

endmodule
