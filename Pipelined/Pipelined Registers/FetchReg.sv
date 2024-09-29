module FetchReg
(
    input  logic        i_Clk,
    input  logic        i_Reset,

    // Input from Hazard Unit
    input  logic        i_StallF,
    
    // Input from Data Path
    input  logic [31:0] i_PCF_Next,

    // Output to Data Path
    output logic [31:0] o_PCF
);

    always_ff @(posedge i_Clk or negedge i_Reset)
        if(~i_Reset)
            o_PCF <= 0;
        else if(~i_StallF)                          // If there is a stall, don't update o_PCF
            o_PCF <= i_PCF_Next;

endmodule