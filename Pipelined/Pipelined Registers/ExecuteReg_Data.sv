module ExecuteReg_Data
(
    input  logic        i_Clk,
    input  logic        i_Reset,

    // Input from Hazard Unit
    input  logic        i_FlushE,

    // Input from Data Path
    input  logic [31:0] i_RD1D, i_RD2D,
    input  logic [31:0] i_PCD,
    input  logic [4:0]  i_Rs1D, i_Rs2D
    input  logic [4:0]  i_RdD,
    input  logic [31:0] i_ImmExtD,
    input  logic [31:0] i_PCPlus4D,

    // Output to Data Path
    output logic [31:0] o_RD1E, o_RD2E,
    output logic [31:0] o_PCE,
    output logic [4:0]  o_Rs1E, o_Rs2E,
    output logic [4:0]  o_RdE,
    output logic [31:0] o_ImmExtE
    output logic [31:0] o_PCPlus4E
);

    // Data Path Register
    always_ff @(posedge i_Clk or negedge i_Reset)
        if(~i_Reset || i_FlushE)                    // Reset or flush clears the register
        begin
            o_RD1E     <= 0;
            o_RD2E     <= 0;
            o_PCE      <= 0;
            o_Rs1E     <= 0;
            o_Rs2E     <= 0;
            o_RdE      <= 0;
            o_ImmExtE  <= 0;
            o_PCPlus4E <= 0;
        end
        else
        begin
            o_RD1E     <= i_RD1D;
            o_RD2E     <= i_RD2D;
            o_PCE      <= i_PCD;
            o_Rs1E     <= i_Rs1D;
            o_Rs2E     <= i_Rs2D;
            o_RdE      <= i_RdD;
            o_ImmExtE  <= i_ImmExtD;
            o_PCPlus4E <= i_PCPlus4D;
        end
endmodule