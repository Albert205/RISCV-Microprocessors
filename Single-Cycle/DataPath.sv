/* Single-cycle processor data path */
module DataPath
(
    input  logic       i_Clk,
    input  logic       i_Reset,
    input  logic       i_PCSrc,
    input  logic [1:0] i_ResultSrc,
    input  logic       i_MemWrite,
    input  logic       i_ALUSrc,
    input  logic [1:0] i_ImmSrc,
    input  logic       i_RegWrite,
    input  logic [2:0] i_ALUControl,

    output logic       o_Zero,
    output logic [6:0] o_OpCode,
    output logic [2:0] o_funct3,
    output logic       o_funct7_5
);

    logic [31:0] w_PCNext;
    logic [31:0] w_PC;
    logic [31:0] w_Instr;
    logic [31:0] w_SrcA;
    logic [31:0] w_SrcB;
    logic [31:0] w_rData_2;
    logic [31:0] w_ALUResult;
    logic [31:0] w_WriteData;
    logic [31:0] w_ReadData;
    logic[ 31:0] w_Result;
    logic [31:0] w_PCTarget;
    logic [31:0] w_ImmExt;
    logic [31:0] w_PCPlus4;

    assign w_PCNext = i_PCSrc ? w_PCTarget : w_PCPlus4;

    PCRegister PCReg_Inst
    (
        .i_Clk(i_Clk),
        .i_Reset(i_Reset),
        .i_PCNext(w_PCNext),
        .o_PC(w_PC)
    );

    assign w_PCPlus4 = w_PC + 32'd4;

    InstructionMemory InstrMem_Inst
    (
        .i_Addr(w_PC),
        .o_Instr(w_Instr)
    );

    assign o_OpCode = w_Instr[6:0];
    assign o_funct3 = w_Instr[14:12];
    assign o_funct7_5 = w_Instr[30]; 

    RegisterFile RegFile_Inst
    (
        .i_Clk(i_Clk),
        .i_Reset(i_Reset),
        .i_wEnable(i_RegWrite),
        .i_rAddr_1(w_Instr[19:15]),
        .i_rAddr_2(w_Instr[24:20]),
        .i_wAddr(w_Instr[11:7]),
        .i_wData(w_Result),
        .o_rData_1(w_SrcA),
        .o_rData_2(w_rData_2)
    );

    assign w_SrcB = i_ALUSrc ? w_ImmExt : w_rData_2;

    ALU ALU_Inst
    (
        .i_SrcA(w_SrcA),
        .i_SrcB(w_SrcB),
        .i_ALUCtrl(i_ALUControl),
        .o_Zero(o_Zero),
        .o_ALUResult(w_ALUResult)
    );

    DataMemory DataMem_Inst
    (
        .i_Clk(i_Clk),
        .i_Reset(i_Reset),
        .i_wEnable(i_MemWrite),
        .i_Addr(w_ALUResult),
        .i_wData(w_rData_2),
        .o_rData(w_ReadData)
    );

    always_comb
    begin
        case(i_ResultSrc)
            2'b00: w_Result = w_ALUResult;
            2'b01: w_Result = w_ReadData;
            2'b10: w_Result = w_PCPlus4;
            default: w_Result = w_ALUResult;
        endcase
    end

    ExtendUnit Ext_Inst
    (
      .i_Imm(w_Instr[31:7]),
      .i_ImmSrc(i_ImmSrc),
      .o_ImmExt(w_ImmExt)  
    );

    assign w_PCTarget = w_ImmExt + w_PC;

endmodule

