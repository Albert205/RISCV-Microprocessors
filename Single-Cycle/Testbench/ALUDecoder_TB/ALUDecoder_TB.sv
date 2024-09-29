`timescale 1ns/1ns

import ALUControl_pkg::*;

module ALUDecoder_TB;

    logic        i_OpCode_5;
    logic [1:0]  i_ALUOp;
    logic [2:0]  i_funct3;
    logic        i_funct7_5;
    ALUControl_t o_ALUControl;

  ALUDecoder uut (.*);

    task getCtrlBits
    (
        input bit OpCode_5,
        input bit [1:0] ALUOp,
        input bit [2:0] funct3,
        input bit funct7_5 
    );

        string operation;

        i_OpCode_5 = OpCode_5;
        i_ALUOp = ALUOp;
        i_funct3 = funct3;
        i_funct7_5 = funct7_5;
        
        #1;

        case(o_ALUControl)
            ADD:     operation = "ADD";
            SUB:     operation = "SUB";
            AND:     operation = "AND";
            OR:      operation = "OR";
            SLT:     operation = "SLT";
            default: operation = "INVALID";
        endcase

        if(i_ALUOp == 2'b00 || i_ALUOp == 2'b01)
            $display("ALUOp: %b\n ALUControl: %b\n Operation: %s\n", i_ALUOp, o_ALUControl, operation);
        else if(i_ALUOp == 2'b10 && i_funct3 == 3'b000)
            $display("ALUOp: %b\n funct3: %b\n {op_5, funct7_5}: %b%b\n ALUControl: %b\n Operation: %s\n", i_ALUOp, i_funct3,i_OpCode_5,i_funct7_5, o_ALUControl, operation);
        else
            $display("ALUOp: %b\n funct3: %b\n ALUControl: %b\n Operation: %s\n", i_ALUOp, i_funct3, o_ALUControl, operation);

    endtask

    initial
    begin
        ALUDecoder_Input decoder_ip = new();
        for(int i = 0; i < 20; i++)
        begin
            #10 decoder_ip.randomize();
            getCtrlBits(.OpCode_5(decoder_ip.op_5), .ALUOp(decoder_ip.ALUOp), .funct3(decoder_ip.funct3), .funct7_5(decoder_ip.funct7_5));
        end
    end

    initial
    begin
        $dumpfile("dump.vcd");
        $dumpvars;
    end
endmodule 