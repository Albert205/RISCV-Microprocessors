module WritebackStage
(
    input  logic        i_Clk,
    input  logic        i_Reset,

    // Output to Hazard Unit
    output logic [4:0]  o_RdW,           // Also used by Data Path

    // Input from Control Unit
    input  logic [1:0]  i_ResultSrcW,

    // Input from Data Path
    input  logic [31:0] i_ALUResultM,
    input  logic [31:0] i_ReadDataM,
    input  logic [4:0]  i_RdM,
    input  logic [31:0] i_PCPlus4M,

    // Output to Data Path
    output logic [31:0] o_ResultW
);

    logic [31:0] w_ALUResultW;
    logic [31:0] w_ReadDataW;
    logic [31:0] w_PCPlus4W;

    WritebackReg_Data WBRegD_Inst
    (
        .i_Clk(i_Clk),
        .i_Reset(i_Reset),
        .i_ALUResultM(i_ALUResultM),
        .i_ReadDataM(i_ReadDataM),
        .i_RdM(i_RdM),
        .i_PCPlus4M(i_PCPlus4M),
        .o_ALUResultW(w_ALUResultW),
        .o_ReadDataW(w_ReadDataW),
        .o_RdW(o_RdW),
        .o_PCPlus4W(w_PCPlus4W)
    );

    // Multiplexer for ResultW
    always_comb
    begin
        o_ResultW = 0;
        case(i_ResultSrcW)
            2'b00: o_ResultW = w_ALUResultW;
            2'b01: o_ResultW = w_ReadDataW;
            2'b10: o_ResultW = w_PCPlus4W;
        endcase
    end

endmodule