/* Top-level module of the multi-cycle processor */

module MultiCycleTop
(
    input logic i_Clk,
    input logic i_Reset
);

    logic w_Zero;
    logic [6:0] w_OpCode;
    logic [2:0] w_funct3;
    logic       w_funct7_5;
    logic       w_PCWrite;
    logic       w_AdrSrc;
    logic       w_IRWrite;
    logic [1:0] w_ResultSrc;
    logic       w_MemWrite;
    logic [1:0] w_ALUSrcA;
    logic [1:0] w_ALUSrcB;
    logic [1:0] w_ImmSrc;
    logic       w_RegWrite;
    logic [2:0] w_ALUControl;

    ControlUnit Ctrl_Inst
    (
        .i_Clk(i_Clk),
        .i_Reset(i_Reset),
        .i_Zero(w_Zero),
        .i_OpCode(w_OpCode),
        .i_funct3(w_funct3),
        .i_funct7_5(w_funct7_5),
        .o_PCWrite(w_PCWrite),
        .o_IRWrite(w_IRWrite),
        .o_AdrSrc(w_AdrSrc),
        .o_ResultSrc(w_ResultSrc),
        .o_MemWrite(w_MemWrite),
        .o_ALUSrcA(w_ALUSrcA),
        .o_ALUSrcB(w_ALUSrcB),
        .o_ImmSrc(w_ImmSrc),
        .o_RegWrite(w_RegWrite),
        .o_ALUControl(w_ALUControl)
    );

    DataPath Data_Inst
    (
       .i_Clk(i_Clk),
       .i_Reset(i_Reset),
       .i_PCWrite(w_PCWrite),
       .i_AdrSrc(w_AdrSrc),
       .i_IRWrite(w_IRWrite),
       .i_ResultSrc(w_ResultSrc),
       .i_MemWrite(w_MemWrite),
       .i_ALUSrcA(w_ALUSrcA),
       .i_ALUSrcB(w_ALUSrcB),
       .i_ImmSrc(w_ImmSrc),
       .i_RegWrite(w_RegWrite),
       .i_ALUControl(w_ALUControl),
       .o_Zero(w_Zero),
       .o_OpCode(w_OpCode),
       .o_funct3(w_funct3),
       .o_funct7_5(w_funct7_5) 
    );

endmodule
