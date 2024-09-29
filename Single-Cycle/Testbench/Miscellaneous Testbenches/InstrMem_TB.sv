`timescale 1ns/1ns

module InstrMem_TB;
    
    logic [31:0] i_Addr;
    logic [31:0] o_Instr;

    InstructionMemory uut 
    (
        .i_Addr(i_Addr), 
        .o_Instr(o_Instr)
    );

    initial
    begin
        $display("Instruction: ");
      for(int i = 0; i < 64; i=i+4)
        begin
          #10 i_Addr = i;
          $display("%h:%h", i_Addr, o_Instr);
        end        
    end
  
    initial
       begin
          $dumpfile("dump.vcd");
          $dumpvars;
       end
endmodule
    

