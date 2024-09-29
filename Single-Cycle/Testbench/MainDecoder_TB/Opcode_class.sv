import Opcode_pkg::*;

class OpCode;
    randc OpCode_t OpCode;

    constraint c_OpCode
    {
        OpCode inside {lw, sw, R_type, addi, jal, no_op};
    }
endclass
