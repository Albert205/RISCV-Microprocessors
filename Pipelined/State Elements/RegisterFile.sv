/* Register file holding register x0 - x31 */

module RegisterFile
(
 input  logic        i_Clk,
 input  logic        i_Reset,
 input  logic        i_wEnable,
 input  logic [4:0]  i_rAddr_1,
 input  logic [4:0]  i_rAddr_2,
 input  logic [4:0]  i_wAddr,
 input  logic [31:0] i_wData,
 output logic [31:0] o_rData_1,
 output logic [31:0] o_rData_2
);

    logic [31:0] r_Reg_Mem [0:31]; // Array holding data of all 32 register

    always_ff @(negedge i_Clk or negedge i_Reset)
        if(~i_Reset)
            for (int i = 0; i < 32; i++)
                r_Reg_Mem[i] <= 0;          // Reset sets all registers to zero
        else if(i_wEnable)
            r_Reg_Mem[i_wAddr] <= i_wData; // Otherwise if write enable asserted, write i_wData to the corresponding register
    

    // Note: If we are reading from the zero register, always return zero
    assign o_rData_1 = (i_rAddr_1 == 5'b0) ? 0 : r_Reg_Mem[i_rAddr_1]; 
    assign o_rData_2 = (i_rAddr_2 == 5'b0) ? 0 : r_Reg_Mem[i_rAddr_2];

endmodule
    
