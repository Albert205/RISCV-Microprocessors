/* Reusable 32b register module */
module Register32b
(
    input  logic        i_Clk,
    input  logic        i_Reset,
    input  logic        i_wEnable,
    input  logic [31:0] i_wData,
    output logic [31:0] o_rData
);

    always_ff @(posedge i_Clk or negedge i_Reset)
        if(~i_Reset)
            o_rData <= 0;
        else if(i_wEnable)
            o_rData <= i_wData;

endmodule
