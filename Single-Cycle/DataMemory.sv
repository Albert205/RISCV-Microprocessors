/* Data memory with a capacity of 256 words */
module DataMemory
(
    input  logic        i_Clk,
    input  logic        i_Reset,
    input  logic        i_wEnable,
    input  logic [31:0] i_Addr,
    input  logic [31:0] i_wData,
    output logic [31:0] o_rData
);

    // localparam MEMDEPTH = 1 << 32;
  logic [31:0] r_Data_Mem [0:255]; // 256-word array

    always_ff @(posedge i_Clk or negedge i_Reset)
        if(~i_Reset)
          for (int i = 0; i < 256; i++)
                r_Data_Mem[i] <= 0;         // Reset sets all data to zero 
        else if(i_wEnable)
            r_Data_Mem[i_Addr] <= i_wData;
    
    assign o_rData = r_Data_Mem[i_Addr];

endmodule