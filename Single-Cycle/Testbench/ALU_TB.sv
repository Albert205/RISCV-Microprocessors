`timescale 1ns/1ns

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

        $display("%h %s %h => %h (Z = %b)", i_SrcA, ALUOp, i_SrcB, o_ALUResult, o_Zero);

    endtask

    initial
    begin
        #10 ALU_OP(.ALUCtrl(ADD), .SrcA(31'hFFFFFFFF), .SrcB(31'h1));
        #10 ALU_OP(.ALUCtrl(ADD), .SrcA(31'h10), .SrcB(31'h5));
        #10 ALU_OP(SUB, 31'hFF, 31'hF);
        #10 ALU_OP(AND, 31'hF, 31'hA);
        #10 ALU_OP(OR, 31'hFF00, 31'h00FF);
        #10 ALU_OP(SLT, 31'hFFFFFFFD, 31'hFFFFFFFC);
    end

    initial
    begin
        $dumpvars;
        $dumpfile("dump.vcd");
    end
endmodule
        



         