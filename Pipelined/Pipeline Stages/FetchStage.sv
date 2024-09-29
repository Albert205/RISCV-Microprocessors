module FetchStage
(
    input  logic        i_Clk,
    input  logic        i_Reset,
    
    // Input from Control Path
    input  logic        i_PCSrcE,

    // Input from Hazard Unit
    input  logic        i_StallF,

    // Input from Data Path
    input  logic [31:0] i_PCTargetE,

    // Output to Data Path
    output logic [31:0] o_InstrF,
    output logic [31:0] o_PCF,
    output logic [31:0] o_PCPlus4F
);

    logic [31:0] w_PCF_Next;
    logic [31:0] w_PCF;
    logic [31:0] w_PCPlus4F;

    assign w_PCF_Next = i_PCSrcE ? i_PCTargetE : w_PCPlus4F; 

    FetchReg F_Reg
    (
        .i_Clk(i_Clk),
        .i_Reset(i_Reset),
        .i_StallF(i_StallF),
        .i_PCF_Next(w_PCF_Next),
        .o_PCF(w_PCF)
    );

    InstructionMemory
    (
        .i_Addr(w_PCF),
        .o_Instr(o_InstrF)
    );

    assign o_PCF = w_PCF;

    assign w_PCPlus4F = w_PCF + 32'd4;
    assign o_PCPlus4F = w_PCPlus4F;

endmodule



