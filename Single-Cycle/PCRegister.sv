/* Register holding the program counter (PC) */

module PCRegister
(
    input logic i_Clk,
    input logic [31:0] i_PCNext,
    input logic i_Reset,
    output logic [31:0] o_PC
);

    always_ff @(posedge i_Clk or negedge i_Reset)
        if(~i_Reset)
            o_PC <= 0;
        else
            o_PC <= i_PCNext;

endmodule
        