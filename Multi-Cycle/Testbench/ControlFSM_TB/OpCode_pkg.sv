package OpCode_pkg;

    typedef enum bit [6:0] {lw = 7'd3, sw = 7'd35, r_type = 7'd51, i_type = 7'd19, jal = 7'd111, beq = 7'd99} OpCode_t;

endpackage : OpCode_pkg