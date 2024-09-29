/* Single-cycle processor data path */
module DataPath
(
    input  logic       i_Clk,
    input  logic       i_Reset,
    input  logic       i_PCWrite,
    input  logic       i_AdrSrc,
    input  logic       i_IRWrite,
    input  logic [1:0] i_ResultSrc,
    input  logic       i_MemWrite,
    input  logic [1:0] i_ALUSrcA,
    input  logic [1:0] i_ALUSrcB,
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
    logic [31:0] w_OldPC;
    logic [31:0] w_Adr;
    logic [31:0] w_Instr;
    logic [31:0] w_SrcA;
    logic [31:0] w_SrcB;
    logic [31:0] w_RD1;
    logic [31:0] w_RD2;
    logic [31:0] w_A;
    logic [31:0] w_ALUResult;
    logic [31:0] w_WriteData;
    logic [31:0] w_ALUOut;
    logic [31:0] w_ReadData;
    logic [31:0] w_Result;
    logic [31:0] w_ImmExt;
    logic [31:0] w_Data;

    // PC Register
    Register32b PCReg 
    (
        .i_Clk(i_Clk),
        .i_Reset(i_Reset),
        .i_wEnable(i_PCWrite),
        .i_wData(w_PCNext),
        .o_rData(w_PC)
    );

    // Multiplexer driving Adr
    assign w_Adr = i_AdrSrc ? w_Result : w_PC;

    // Instr / Data Memory
    InstrDataMemory InstrDataMem
    (
        .i_Clk(i_Clk),
        .i_Reset(i_Reset),
        .i_wEnable(i_MemWrite),
        .i_Addr(w_Adr),
        .i_wData(w_WriteData),
        .o_rData(w_ReadData)
    );

    // ReadData Register
    Register32b DataReg
    (
        .i_Clk(i_Clk),
        .i_Reset(i_Reset),
        .i_wEnable(1'b1),
        .i_wData(w_ReadData),
        .o_rData(w_Data)
    );

    // OldPC Register
    Register32b OldPCReg
    (
        .i_Clk(i_Clk),
        .i_Reset(i_Reset),
        .i_wEnable(i_IRWrite),
        .i_wData(w_PC),
        .o_rData(w_OldPC)
    );

    // Instr Register
    Register32b InstrReg
    (
        .i_Clk(i_Clk),
        .i_Reset(i_Reset),
        .i_wEnable(i_IRWrite),
        .i_wData(w_ReadData),
        .o_rData(w_Instr)
    );

    // Drive relevant bits to the control unit
    assign o_OpCode = w_Instr[6:0];
    assign o_funct3 = w_Instr[14:12];
    assign o_funct7_5 = w_Instr[30]; 

    // Register file (x0 - x31)
    RegisterFile RegFile_Inst
    (
        .i_Clk(i_Clk),
        .i_Reset(i_Reset),
        .i_wEnable(i_RegWrite),
        .i_rAddr_1(w_Instr[19:15]),
        .i_rAddr_2(w_Instr[24:20]),
        .i_wAddr(w_Instr[11:7]),
        .i_wData(w_Result),
        .o_rData_1(w_RD1),
        .o_rData_2(w_RD2)
    );

    // RD1 Register
    Register32b RD1Reg
    (
        .i_Clk(i_Clk),
        .i_Reset(i_Reset),
        .i_wEnable(1'b1),
        .i_wData(w_RD1),
        .o_rData(w_A) 
    );

    // RD2 Register
    Register32b RD2Reg
    (
        .i_Clk(i_Clk),
        .i_Reset(i_Reset),
        .i_wEnable(1'b1),
        .i_wData(w_RD2),
        .o_rData(w_WriteData) 
    );

    // Multiplexer driving SrcA
    always_comb
    begin
        w_SrcA = w_PC;
        case(i_ALUSrcA)
            2'b00:
            2'b01: w_SrcA = w_OldPC;
            2'b10: w_SrcA = w_A;
        endcase
    end

    // Multiplexer driving SrcB
    always_comb
    begin
        w_SrcB = w_WriteData;
        case(i_ALUSrcB)
            2'b00:
            2'b01: w_SrcB = w_ImmExt;
            2'b10: w_SrcB = 32'd4;
        endcase
    end

    // ALU Instantiation
    ALU ALU_Inst
    (
        .i_SrcA(w_SrcA),
        .i_SrcB(w_SrcB),
        .i_ALUCtrl(i_ALUControl),
        .o_Zero(o_Zero),
        .o_ALUResult(w_ALUResult)
    );

    // ALUResult Register
    Register32b ALUReg
    (
        .i_Clk(i_Clk),
        .i_Reset(i_Reset),
        .i_wEnable(1'b1),
        .i_wData(w_ALUResult),
        .o_rData(w_ALUOut)
    )

    // Multiplexer driving Result
    always_comb
    begin
        w_Result = w_ALUOut;
        case(i_ResultSrc)
            2'b00: 
            2'b01: w_Result = w_Data;
            2'b10: w_Result = w_ALUResult;
        endcase
    end

    // ExtendUnit Instantiation
    ExtendUnit Ext_Inst
    (
      .i_Imm(w_Instr[31:7]),
      .i_ImmSrc(i_ImmSrc),
      .o_ImmExt(w_ImmExt)  
    );

endmodule

