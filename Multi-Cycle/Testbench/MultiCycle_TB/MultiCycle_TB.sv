`timescale 1ns/1ns

module MultiCycle_TB;

    localparam T = 10;

    logic i_Clk;
    logic i_Reset;

    MultiCycleTop uut (.*);

    always
    begin
        i_Clk = 1'b1;
        #(T/2);
        i_Clk = 1'b0;
        #(T/2);
    end

    initial
    begin
        i_Reset = 1'b1;
        #(T/2);
        i_Reset = 1'b0;
        #(T/2);
        i_Reset = 1'b1;
    end

    initial
    begin
        @(negedge i_Reset);

        repeat (100) @(negedge i_Clk);
        $finish;
    end

    initial
    begin
        $dumpfile("dump.vcd");
        $dumpvars;
    end

endmodule