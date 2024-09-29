module ImmDecoder
(
    input  logic [6:0] i_OpCode,
    output logic [1:0] o_ImmSrc
);

    typedef enum logic [6:0] {lw = 7'd3, sw = 7'd35, r_type = 7'd51, i_type = 7'd19, jal = 7'd111, beq = 7'd99} OpCode_t;

    always_comb
    begin
        o_ImmSrc = 2'b00;
        case(i_OpCode)
            sw:         o_ImmSrc = 2'b01;
            jal:        o_ImmSrc = 2'b11;
            beq:        o_ImmSrc = 2'b10;
        endcase
    end

endmodule