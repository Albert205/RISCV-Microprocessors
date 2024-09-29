module ExecuteStage
(
    input  logic       i_Clk,
    input  logic       i_Reset,

    // Input from Hazard Unit
    input  logic       i_FlushE,
    input  logic [1:0] i_ForwardAE,
    input  logic [1:0] i_ForwardBE,

    // Output to Hazard Unit
    output logic [4:0] o_Rs1E, o_Rs2E,
    output logic [4:0] o_RdE,           // Also used by Data Path

    // Input from Control Path
    input  logic [2:0] i_ALUControlE,
    input  logic       i_ALUSrcE,

    // Output to Control Path
    output logic o_ZeroE,

    // Input from Data Path
    input  logic [31:0] i_RD1D, i_RD2D,
    input  logic [31:0] i_PCD,
    input  logic [4:0]  i_Rs1D, i_Rs2D,
    input  logic [4:0]  i_RdD,
    input  logic [31:0] i_ImmExtD,
    input  logic [31:0] i_PCPlus4D,
    input  logic [31:0] i_ALUResultM,
    input  logic [31:0] i_ResultW,

    // Output to Data Path
    output logic [31:0] o_ALUResultE,
    output logic [31:0] o_WriteDataE,
    output logic [31:0] o_PCTargetE,
    output logic [31:0] o_PCPlus4E 
);

    logic [31:0] w_RD1E, w_RD2E;
    logic [31:0] w_PCE;
    logic [31:0] w_ImmExtE;

    logic [31:0] w_SrcAE, w_SrcBE;
    logic [31:0] w_WriteDataE;

    assign o_WriteDataE = w_WriteDataE;

    ExecuteReg_Data ExecRegD_Inst
    (
        .i_Clk(i_Clk),
        .i_Reset(i_Reset),
        .i_FlushE(i_FlushE),
        .i_RD1D(i_RD1D),
        .i_RD2D(i_RD2D),
        .i_PCD(i_PCD),
        .i_Rs1D(i_Rs1D),
        .i_Rs2D(i_Rs2D),
        .i_RdD(i_RdD),
        .i_ImmExtD(i_ImmExtD),
        .i_PCPlus4D(i_PCPlus4D),
        .o_RD1E(w_RD1E),
        .o_RD2E(w_RD2E),
        .o_PCE(w_PCE),
        .o_Rs1E(o_Rs1E),
        .o_Rs2E(o_Rs2E),
        .o_RdE(o_RdE),
      	.o_ImmExtE(w_ImmExtE),
      	.o_PCPlus4E(o_PCPlus4E)
    );

    // Multiplexer for SrcAE
    always_comb 
    begin
        w_SrcAE = 0;
        case(i_ForwardAE)
            2'b00: w_SrcAE = w_RD1E;
            2'b01: w_SrcAE = i_ResultW;
            2'b10: w_SrcAE = i_ALUResultM;
        endcase
    end

    // Multiplexer for WriteDataE
    always_comb
    begin
        w_WriteDataE = 0;
        case(i_ForwardBE)
            2'b00: w_WriteDataE = w_RD2E;
            2'b01: w_WriteDataE = i_ResultW;
            2'b10: w_WriteDataE = i_ALUResultM;
        endcase
    end

    // Multiplexer for SrcBE
    assign w_SrcBE = i_ALUSrcE ? w_ImmExtE : w_WriteDataE;

    // Adder for PCE and ImmExtE
    assign o_PCTargetE = w_PCE + w_ImmExtE;

    ALU ALU_Inst
    (
        .i_SrcA(w_SrcAE),
        .i_SrcB(w_SrcBE),
        .i_ALUCtrl(i_ALUControlE),
        .o_Zero(o_ZeroE),
        .o_ALUResult(o_ALUResultE)
    );

endmodule


