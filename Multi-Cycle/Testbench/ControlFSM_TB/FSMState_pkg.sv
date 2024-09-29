package FSMState_pkg;

    typedef enum logic [3:0] {FETCH, DECODE, MEMADR, MEMREAD, MEMWB, MEMWRITE, EXECUTER, ALUWB, EXECUTEL, JAL, BEQ} StateType_t;

endpackage : FSMState_pkg