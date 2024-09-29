`timescale 1ns/1ns

import   OpCode_pkg::*;
import FSMState_pkg::*;

module ControlFSM_TB;

    localparam T = 10;

    OpCode_t i_OpCode;

    bit Reset_Complete;

    logic       i_Clk;
    logic       i_Reset;
    logic       o_Branch;
    logic       o_PCUpdate;
    logic       o_IRWrite;
    logic [1:0] o_ResultSrc;
    logic       o_MemWrite;
    logic [1:0] o_ALUSrcA;
    logic [1:0] o_ALUSrcB;
    logic       o_RegWrite;
    logic [1:0] o_ALUOp;
    logic       o_AdrSrc;
    logic [3:0] o_State;

    ControlFSM uut (.*);

    task print();
        string instruction, fsm_state;
        case(i_OpCode)
            lw:      instruction = "lw";
            sw:      instruction = "sw";
            r_type:  instruction = "R-type";
            i_type:  instruction = "I-type";
            jal:     instruction = "jal";
            beq:     instruction = "beq";
            default: instruction = "INVALID";
        endcase

        case(o_State)
            FETCH:    fsm_state = "Fetch";
            DECODE:   fsm_state = "Decode";
            MEMADR:   fsm_state = "MemAdr";
            MEMREAD:  fsm_state = "MemRead";
            MEMWB:    fsm_state = "MemWB";
            MEMWRITE: fsm_state = "MemWrite";
            EXECUTER: fsm_state = "ExecuteR";
            EXECUTEL: fsm_state = "ExecuteL";
            ALUWB:    fsm_state = "ALUWB";
            JAL:      fsm_state = "JAL";
            BEQ:      fsm_state = "BEQ";
            default:  fsm_state = "INVALID";
        endcase

        $display("Instruction: %s\n FSMState: %s\n Branch: %b\n PCUpdate: %b\n RegWrite: %b\n MemWrite: %b\n IRWrite: %b\n ResultSrc: %b\n ALUSrcA: %b\n ALUSrcB: %b\n AdrSrc: %b\n ALUOp: %b\n", instruction, fsm_state, o_Branch, o_PCUpdate, o_RegWrite, o_MemWrite, o_IRWrite, o_ResultSrc, o_ALUSrcA, o_ALUSrcB, o_AdrSrc, o_ALUOp);
    endtask

    always @(posedge i_Clk)
        if(Reset_Complete)
            print();

    always
    begin
        i_Clk = 1'b1;
        #(T/2);
        i_Clk = 1'b0;
        #(T/2);
    end

    initial 
    begin
        i_Reset = 1'b1;
        #(T/2);
        i_Reset = 1'b0;
        #(T/2);
        i_Reset = 1'b1;
    end

    OpCode_class c_OpCode;

    initial
    begin
        Reset_Complete = 1'b0;
        c_OpCode = new(); 

        @(posedge i_Reset);
        Reset_Complete = 1'b1;

        for(int i = 0; i < 6; i++)
        begin
            wait(o_State == FETCH);
            $display("Instruction #%d", i);
            c_OpCode.randomize();
            i_OpCode = c_OpCode.OpCode;
            wait(o_State == MEMWB || o_State == MEMWRITE || o_State == ALUWB || o_State == BEQ);
        end

        #30 $finish;

    end

    initial
    begin
        $dumpfile("dump.vcd");
        $dumpvars;
    end
endmodule

