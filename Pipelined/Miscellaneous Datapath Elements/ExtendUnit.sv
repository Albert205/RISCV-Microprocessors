/* Extends immediate from instruction to 32b */
module ExtendUnit
(
    input logic  [31:7] i_Imm,
    input logic  [1:0]  i_ImmSrc,
    output logic [31:0] o_ImmExt
);
    typedef enum logic[1:0] {I, S, B, J} InstrType;

    always_comb 
    begin
        case(i_ImmSrc)
            I:  o_ImmExt = {{20{i_Imm[31]}}, i_Imm[31:20]};
            S:  o_ImmExt = {{20{i_Imm[31]}}, i_Imm[31:25], i_Imm[11:7]};
            B:  o_ImmExt = {{20{i_Imm[31]}}, i_Imm[7], i_Imm[30:25], i_Imm[11:8], 1'b0};
            J:  o_ImmExt = {{12{i_Imm[31]}}, i_Imm[19:12], i_Imm[20], i_Imm[30:21], 1'b0};
        endcase
    end

endmodule