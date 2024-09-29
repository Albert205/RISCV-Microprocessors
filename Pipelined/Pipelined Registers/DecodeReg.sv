module DecodeReg
(
    input  logic        i_Clk,
    input  logic        i_Reset,

    // Input from Hazard Unit
    input  logic        i_StallD,
    input  logic        i_FlushD,

    // Input from Data Path
    input  logic [31:0] i_InstrF,
    input  logic [31:0] i_PCF,
    input  logic [31:0] i_PCPlus4F,

    // Output to Data Path
    output logic [31:0] o_InstrD,
    output logic [31:0] o_PCD,
    output logic [31:0] o_PCPlus4D
);

    always_ff @(posedge i_Clk or negedge i_Reset)
        if(~i_Reset | i_FlushD)
        begin
            o_InstrD   <= 0;
            o_PCD      <= 0;
            o_PCPlus4D <= 0;
        end
        else if(~i_StallD)
        begin
            o_InstrD   <= i_InstrF;
            o_PCD      <= i_PCF;
            o_PCPlus4D <= i_PCPlus4F;
        end

endmodule