/* Outputs control signals for the ALU */
module ALUDecoder
(
    input  logic       i_OpCode_5,
    input  logic [1:0] i_ALUOp,
    input  logic [2:0] i_funct3,
    input  logic       i_funct7_5,
    output logic [2:0] o_ALUControl
);

    typedef enum logic[2:0] {ADD = 3'b000, SUB = 3'b001, SLT = 3'b101, OR = 3'b011, AND = 3'b010} ALUOp;

    always_comb 
    begin
        case(i_ALUOp)
            2'b00: o_ALUControl = ADD; // ADD 
            2'b01: o_ALUControl = SUB; // SUB
            2'b10:
            begin
                case(i_funct3)
                    3'b000: o_ALUControl = (i_OpCode_5 & i_funct7_5) ? SUB : ADD;
                    3'b010: o_ALUControl = SLT;
                    3'b110: o_ALUControl = OR;
                    3'b111: o_ALUControl = AND;
                endcase
            end
            default: o_ALUControl = ADD;
        endcase
    end

endmodule