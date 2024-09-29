module MemoryReg_Ctrl
(
    input  logic       i_Clk,
    input  logic       i_Reset,

    // Input from Control Path
    input  logic       i_RegWriteE,
    input  logic [1:0] i_ResultSrcE,
    input  logic       i_MemWriteE,

    // Output to Control Path
    output logic       o_RegWriteM,
    output logic [1:0] o_ResultSrcM,
    output logic       o_MemWriteM
);

    // Control Path Register
    always @(posedge i_Clk or negedge i_Reset)
        if(~i_Reset)
        begin
            o_RegWriteM  <= 0;
            o_ResultSrcM <= 0;
            o_MemWriteM  <= 0;
        end
        else
        begin
            o_RegWriteM  <= i_RegWriteE;
            o_ResultSrcM <= i_ResultSrcE;
            o_MemWriteM  <= i_MemWriteE;
        end
endmodule