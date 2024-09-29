/* Decodes 7-bit op-code into control signals */
module MainDecoder
(
    input  logic [6:0] i_OpCode, 
    output logic       o_Branch,
    output logic       o_Jump,
    output logic [1:0] o_ResultSrc,
    output logic       o_MemWrite,
    output logic       o_ALUSrc,
    output logic [1:0] o_ImmSrc,
    output logic       o_RegWrite,
    output logic [1:0] o_ALUOp
);

    always_comb
    begin
        // Default case is no-op
        o_Branch    = 1'b0;
        o_Jump      = 1'b0;
        o_ResultSrc = 2'b0;
        o_MemWrite  = 1'b0;
        o_ALUSrc    = 1'b0;
        o_ImmSrc    = 2'b0;
        o_RegWrite  = 1'b0;
        o_ALUOp     = 2'b0;
        case(i_OpCode)
            7'd3:   // lw
            begin
                o_RegWrite  = 1'b1;
                o_ALUSrc    = 1'b1;
                o_MemWrite  = 1'b0;
                o_ResultSrc = 2'b01;
            end
            7'd35:  // sw
            begin
                o_RegWrite = 1'b0;
                o_ImmSrc   = 2'b01;
                o_ALUSrc   = 1'b1;
                o_MemWrite = 1'b1;
            end
            7'd51:  // R-type
            begin
                o_RegWrite = 1'b1;
                o_ALUOp    = 2'b10;
            end
            7'd99:  // beq
            begin
                o_ImmSrc = 2'b10;
                o_Branch = 1'b1;
                o_ALUOp  = 2'b01;
            end
            7'd19:  // addi
            begin
                o_RegWrite = 1'b1;
                o_ALUSrc   = 1'b1;
                o_ALUOp    = 2'b10;
            end
            7'd111: // jal
            begin
                o_RegWrite  = 1'b1;
                o_ImmSrc    = 2'b11;
                o_ResultSrc = 2'b10;
                o_Jump      = 1'b1;
            end
        endcase
    end

endmodule