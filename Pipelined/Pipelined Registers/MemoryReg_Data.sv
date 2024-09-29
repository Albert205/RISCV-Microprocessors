module MemoryReg_Data
(
    input logic i_Clk,
    input logic i_Reset,

    // Input from Data Path
    input logic [31:0] i_ALUResultE,
    input logic [31:0] i_WriteDataE,
    input logic [4:0]  i_RdE,
    input logic [31:0] i_PCPlus4E,

    // Output to Data Path
    output logic [31:0] o_ALUResultM,
    output logic [31:0] o_WriteDataM,
    output logic [4:0]  o_RdM,
    output logic [31:0] o_PCPlus4M
);
    
    // Data Path Register
    always @(posedge i_Clk or negedge i_Reset)
        if(~i_Reset)
        begin
            o_ALUResultM <= 0;
            o_WriteDataM <= 0;
            o_RdM        <= 0;
            o_PCPlus4M   <= 0;
        end
        else
        begin
            o_ALUResultM <= i_ALUResultE;
            o_WriteDataM <= i_WriteDataE;
            o_RdM        <= i_RdE;
            o_PCPlus4M   <= i_PCPlus4E;
        end

endmodule