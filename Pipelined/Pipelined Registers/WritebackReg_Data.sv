module WritebackReg_Data
(
    input  logic        i_Clk,
    input  logic        i_Reset,

    // Input from Data Path
    input  logic [31:0] i_ALUResultM,
    input  logic [31:0] i_ReadDataM,
    input  logic [4:0]  i_RdM,
    input  logic [31:0] i_PCPlus4M,

    // Output to Data Path
    output logic [31:0] o_ALUResultW,
    output logic [31:0] o_ReadDataW,
    output logic [4:0]  o_RdW,
    output logic [31:0] o_PCPlus4W
);

    // Data Path Register
    always @(posedge i_Clk or negedge i_Reset)
        if(~i_Reset)
        begin
            o_ALUResultW <= 0;
            o_ReadDataW  <= 0;
            o_RdW        <= 0;
            o_PCPlus4W   <= 0;
        end
        else
        begin
            o_ALUResultW <= i_ALUResultM;
            o_ReadDataW  <= i_ReadDataM;
            o_RdW        <= i_RdM;
            o_PCPlus4W   <= i_PCPlus4M;
        end

endmodule