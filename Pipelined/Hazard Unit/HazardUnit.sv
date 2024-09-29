/* Hazard unit to deal with data and control hazards */ 
module HazardUnit
(
    // Input from Data Path
    input  logic [4:0] i_Rs1D, i_Rs2D,
    input  logic [4:0] i_Rs1E, i_Rs2E,
    input  logic [4:0] i_RdE,
    input  logic [4:0] i_RdM,
    input  logic [4:0] i_RdW,

    // Input from Control Path
    input  logic       i_PCSrcE,
    input  logic       i_ResultSrcE_0,
    input  logic       i_RegWriteM,
    input  logic       i_RegWriteW,

    // Output to Data Path
    output logic       o_StallF,
    output logic       o_StallD,
    output logic       o_FlushD,
    output logic       o_FlushE,
    output logic [1:0] o_ForwardAE,
    output logic [1:0] o_ForwardBE
);

    logic w_lwStall; // Load hazard stall signal

    /* Forward to solve data hazards when possible*/
    always_comb 
    begin
        /* SrcA */
        if((i_Rs1E == i_RdM) && i_RegWriteM && (i_Rs1E != 5'b0))
            o_ForwardAE = 2'b10;
        else if((i_Rs1E == i_RdW) && i_RegWriteW && (i_Rs1E != 5'b0))
            o_ForwardAE = 2'b01;
        else
            o_ForwardAE = 2'b00;  

        /* SrcB */
        if((i_Rs2E == i_RdM) && i_RegWriteM && (i_Rs2E != 5'b0))
            o_ForwardBE = 2'b10;
        else if((i_Rs2E == i_RdW) && i_RegWriteW && (i_Rs2E != 5'b0))
            o_ForwardBE = 2'b01;
        else
            o_ForwardBE = 2'b00;
    end

    /* Stall when a load hazard occurs */
    assign w_lwStall = i_ResultSrcE_0 & ((i_Rs1 == i_RdE) | (i_Rs2D == i_RdE));
    assign o_StallF  = w_lwStall;
    assign o_StallD  = w_lwStall;

    /* Flush when a branch is taken or a load introduces a bubble */
    assign o_FlushD = i_PCSrcE;
    assign o_FlushE = w_lwStall | i_PCSrcE;

endmodule

