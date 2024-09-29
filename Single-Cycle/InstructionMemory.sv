/* Instruction memory holding 64 words*/
module InstructionMemory
(
    input  logic [31:0] i_Addr,
    output logic [31:0] o_Instr
);

    // localparam MEMDEPTH = 1 << 30;
  logic [31:0] r_Instr_Mem [0:31];
    
    initial
        $readmemh("Instructions.txt", r_Instr_Mem);
    
    assign o_Instr = r_Instr_Mem[i_Addr[31:2]];
    
endmodule