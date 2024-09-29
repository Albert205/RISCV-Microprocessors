module InstrDataMemory
(
    input  logic        i_Clk,
    input  logic        i_Reset,
  	input  logic		i_AdrSrc,
    input  logic        i_wEnable,
    input  logic [31:0] i_Addr,
    input  logic [31:0] i_wData,
    output logic [31:0] o_rData
);

  logic [31:0] r_InstrData_Mem [0:127]; // 128 memory locations for instructions and data (bottom 1/2 for instructions, top 1/2 for data)

    initial
        $readmemh("Instructions.txt", r_InstrData_Mem);
    
    always_ff @(posedge i_Clk or negedge i_Reset)
        if(~i_Reset)
          for(int i = 64; i < 128; i++)
                r_InstrData_Mem[i] <= 0;
        else if(i_wEnable)
            r_InstrData_Mem[i_Addr] <= i_wData;

  assign o_rData = i_AdrSrc ? r_InstrData_Mem[i_Addr] : r_InstrData_Mem[i_Addr[31:2]];

endmodule