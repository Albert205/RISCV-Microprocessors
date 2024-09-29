module ALU
(
    input  logic [31:0] i_SrcA,
    input  logic [31:0] i_SrcB,
    input  logic [2:0]  i_ALUCtrl,
    output logic        o_Zero,
    output logic [31:0] o_ALUResult
);

    logic [31:0] w_Sum;
    logic        w_Overflow;
    logic        w_SLT;

    typedef enum logic [2:0] {ADD = 3'b000, SUB = 3'b001, AND = 3'b010, OR = 3'b011, SLT = 3'b101} ALUOp;

    assign w_Sum = (i_ALUCtrl[0]) ? i_SrcA + ~i_SrcB + 1 : i_SrcA + i_SrcB;
    assign w_Overflow = (~(i_ALUCtrl[0] ^ i_SrcA[31] ^ i_SrcB[31])) & (i_SrcA[31] ^ w_Sum[31]) & (~i_ALUCtrl[1]);
    assign w_SLT =  w_Overflow ^ w_Sum[31];

    always_comb 
    begin
        case(i_ALUCtrl)
            ADD: o_ALUResult = w_Sum;
            SUB: o_ALUResult = w_Sum;   
            AND: o_ALUResult = i_SrcA & i_SrcB;
            OR:  o_ALUResult = i_SrcA | i_SrcB;
            SLT: o_ALUResult = {{31{1'b0}}, w_SLT};
            default: o_ALUResult = 32'bZ;
        endcase
    end

    assign o_Zero = (o_ALUResult == 32'b0);
endmodule