module ControlFSM
(
    input  logic       i_Clk,
    input  logic       i_Reset,
    input  logic [6:0] i_OpCode,
    output logic       o_Branch,
    output logic       o_PCUpdate,
    output logic       o_RegWrite,
    output logic       o_MemWrite,
    output logic       o_IRWrite,
    output logic [1:0] o_ResultSrc,
    output logic [1:0] o_ALUSrcA,
    output logic [1:0] o_ALUSrcB,
    output logic       o_AdrSrc,
    output logic [1:0] o_ALUOp,
    output logic [3:0] o_State
);

    typedef enum logic [6:0] {lw = 7'd3, sw = 7'd35, r_type = 7'd51, i_type = 7'd19, jal = 7'd111, beq = 7'd99}     OpCode_t;
    typedef enum logic [3:0] {FETCH, DECODE, MEMADR, MEMREAD, MEMWB, MEMWRITE, EXECUTER, ALUWB, EXECUTEL, JAL, BEQ} StateType_t;
    StateType_t s_State, s_State_Next;
  
  	assign o_State = s_State;

    // FSM
    always_ff @(posedge i_Clk or negedge i_Reset)
        if(~i_Reset)
            s_State <= FETCH;
        else
            s_State <= s_State_Next;

    // Next-state logic
    always_comb
    begin
        s_State_Next = FETCH;
        case(s_State)
            FETCH: 
                s_State_Next = DECODE;
            DECODE:
                begin
                    if(i_OpCode == lw || i_OpCode == sw)
                        s_State_Next = MEMADR;
                    else if(i_OpCode == r_type)
                        s_State_Next = EXECUTER;
                    else if(i_OpCode == i_type)
                        s_State_Next = EXECUTEL;
                    else if(i_OpCode == jal)
                        s_State_Next = JAL;
                  else if(i_OpCode == beq)
                        s_State_Next = BEQ;
                end
            MEMADR:
                if(i_OpCode == lw)
                    s_State_Next = MEMREAD;
                else
                    s_State_Next = MEMWRITE;
            MEMREAD: 
                s_State_Next = MEMWB;
            MEMWRITE:
                s_State_Next = FETCH; 
            EXECUTER:
                s_State_Next = ALUWB;
            ALUWB:
                s_State_Next = FETCH;
            EXECUTEL:
                s_State_Next = ALUWB;
            JAL:
                s_State_Next = ALUWB;
            BEQ:
                s_State_Next = FETCH;
        endcase
    end

    // Output logic
    always_comb
    begin
      	o_Branch    = 1'b0;
        o_PCUpdate  = 1'b0;
        o_RegWrite  = 1'b0;
        o_MemWrite  = 1'b0;
        o_IRWrite   = 1'b0;
        o_ResultSrc = 2'b00;
        o_ALUSrcA   = 2'b00;
        o_ALUSrcB   = 2'b00;
        o_AdrSrc    = 1'b0;
        o_ALUOp     = 2'b0;
        case(s_State)
            FETCH:
                begin
                    o_IRWrite   = 1'b1;
                    o_ALUSrcB   = 2'b10;
                    o_ResultSrc = 2'b10;
                    o_PCUpdate  = 1'b1;
                end
            DECODE:
                begin
                    o_ALUSrcA = 2'b01;
                    o_ALUSrcB = 2'b01;
                end
            MEMADR:
                begin
                    o_ALUSrcA = 2'b10;
                    o_ALUSrcB = 2'b01;
                end                    
            MEMREAD:
                begin
                    o_AdrSrc = 1'b1;
                end
            MEMWB:
                begin
                    o_ResultSrc = 2'b01;
                    o_RegWrite  = 1'b1;
                end
            MEMWRITE:
                begin
                    o_AdrSrc   = 1'b1;
                    o_MemWrite = 1'b1;
                end
            EXECUTER:
                begin
                    o_ALUSrcA = 2'b10;
                    o_ALUOp   = 2'b10;
                end
            ALUWB:
                begin
                    o_RegWrite = 1'b1;
                end
            EXECUTEL:
                begin
                    o_ALUSrcA = 2'b10;
                    o_ALUSrcB = 2'b01;
                    o_ALUOp   = 2'b10;
                end
            JAL:
                begin
                    o_ALUSrcA  = 2'b01;
                    o_ALUSrcB  = 2'b10;
                    o_PCUpdate = 1'b1;
                end
            BEQ:
                begin
                    o_ALUSrcA = 2'b10;
                    o_ALUOp   = 2'b01;
                    o_Branch  = 1'b1;
                end
        endcase
    end

endmodule


    

