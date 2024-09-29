`timescale 1ns/1ns

import Opcode_pkg::*;

module MainDecoder_TB;

    OpCode_t i_OpCode;
    
    logic       o_Branch;
    logic       o_Jump;
    logic [1:0] o_ResultSrc;
    logic       o_MemWrite;
    logic       o_ALUSrc;
    logic [1:0] o_ImmSrc;
    logic       o_RegWrite;
    logic [1:0] o_ALUOp;

    MainDecoder uut (.*);

    task getCtrlBits
    (
        input OpCode_t OpCode
    );
        string instruction;
        i_OpCode = OpCode;

        case(i_OpCode)
            lw:      instruction = "lw";
            sw:      instruction = "sw";
            R_type:  instruction = "R-type";
            addi:    instruction = "addi";
            jal:     instruction = "jal";
            no_op:   instruction = "no-op";
            default: instruction = "INVALID";
        endcase


        #1 $display("Instruction: %s\n Op: %b\n RegWrite: %b\n ImmSrc: %b\n ALUSrc: %b\n MemWrite: %b\n ResultSrc: %b\n Branch: %b\n Jump: %b\n ALUOp: %b\n", instruction, i_OpCode, o_RegWrite, o_ImmSrc, o_ALUSrc, o_MemWrite, o_ResultSrc, o_Branch, o_Jump, o_ALUOp);
    endtask

    initial
    begin
        OpCode op = new();
        for(int i = 0; i < 10; i++)
        begin
            #10 op.randomize();
            getCtrlBits(.OpCode(op.OpCode));
        end
    end

    initial
    begin
        $dumpfile("dump.vcd");
        $dumpvars;
    end
endmodule

