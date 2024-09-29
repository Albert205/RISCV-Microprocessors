package Opcode_pkg;

    typedef enum bit[6:0] {lw = 7'd3, sw = 7'd35, R_type = 7'd51, addi = 7'd19, jal = 7'd111, no_op = 7'd0} OpCode_t;

endpackage : Opcode_pkg