`timescale 1ns/1ps

module ALU_TB;
    logic [31:0] i_SrcA, i_SrcB;
    logic [2:0] i_ALUCtrl;
    logic o_Zero;
    logic [31:0] o_ALUResult;

    typedef enum logic [2:0] {ADD = 3'b000, SUB = 3'b001, AND = 3'b010, OR = 3'b011, SLT = 3'b101} ALUOp;


    ALU uut (.*);

    task ALU_OP
    (
        input bit[2:0] ALUCtrl,
        input bit[31:0] SrcA, SrcB
    );
        string ALUOp;

        i_ALUCtrl = ALUCtrl;
        i_SrcA = SrcA;
        i_SrcB = SrcB;

        case(ALUCtrl)
            ADD: ALUOp = "ADD";
            SUB: ALUOp = "SUB";
            AND: ALUOp = "AND";
            OR:  ALUOp = "OR";
            SLT: ALUOp = "SLT";
            default: ALUOp = "INVALID";
        endcase

        #1ps $display("%h %s %h => %h (Z = %b)", i_SrcA, ALUOp, i_SrcB, o_ALUResult, o_Zero);

    endtask

    initial
    begin
      	#10 ALU_OP(.ALUCtrl(ADD), .SrcA(32'hFFFFFFFF), .SrcB(32'h1));
        #10 ALU_OP(.ALUCtrl(ADD), .SrcA(32'h10), .SrcB(32'h5));
        #10 ALU_OP(SUB, 32'hFF, 32'hF);
        #10 ALU_OP(AND, 32'hF, 32'hA);
        #10 ALU_OP(OR, 32'hFF00, 32'h00FF);
      #10 ALU_OP(SLT, 32'h1, 32'h80000000);
      #10 ALU_OP(SLT, 32'h7FFFFFFE, 32'hFFFFFFFF);
      	#10 ALU_OP(ADD, 32'h7FFFFFFE, 32'h7FFFFFFF);
      	#10 ALU_OP(SUB, 32'h7FFFFFFE, 32'h7FFFFFFF);
      	#50 $finish;
    end

    initial
    begin
        $dumpvars;
        $dumpfile("dump.vcd");
    end
endmodule
        



         