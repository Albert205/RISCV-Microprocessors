
class ALUDecoder_Input;
    rand bit[1:0] ALUOp;
    rand bit[2:0] funct3;
    rand bit op_5;
    rand bit funct7_5;

    constraint c_ALUOp
    {
        ALUOp dist
        {
            2'b00 := 1,
            2'b01 := 1,
            2'b10 := 4,
            2'b11 := 0
        };
    }

    constraint c_funct3
    {
        if(ALUOp == 2'b10)
            funct3 inside {3'b000, 3'b010, 3'b110, 3'b111};
        
        funct3 dist
        {
            3'b000 := 6,
            3'b010 := 1,
            3'b110 := 1,
            3'b111 := 1
        };
    }

    constraint c_op5_funct75
    {
        if(funct3 == 3'b000)
            {op_5, funct7_5} inside {2'b00:2'b11};
    }

endclass