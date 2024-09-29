module WritebackReg_Ctrl
(
    input  logic        i_Clk,
    input  logic        i_Reset,

    // Input from Control Path
    input  logic        i_RegWriteM,
    input  logic [1:0]  i_ResultSrcM,

    // Output to Control Path
    output logic        o_RegWriteW,
    output logic [1:0]  o_ResultSrcW
);

    // Control Path Register
    always @(posedge i_Clk or negedge i_Reset)
        if(~i_Reset)
        begin
            o_RegWriteW  <= 0;
            o_ResultSrcW <= 0;
        end
        else
        begin
            o_RegWriteW  <= i_RegWriteM;
            o_ResultSrcW <= i_ResultSrcM;
        end

endmodule