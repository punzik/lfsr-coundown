`timescale 1ps/1ps
 `include "hut.svh"

/* verilator lint_off INITIALDLY */

module lfsr_tb;
    logic clock = 1'b0;
    initial forever #(10ns/2) clock = ~clock;

    parameter POLY = 16'b1101_0000_0000_1000;
    localparam SIZE = $clog2(POLY);

    logic i_enable;
    logic [SIZE-1:0] o_sreg_unused;

    lfsr #(.POLY(POLY))
    u_lfsr (.clock,
            .i_reset(1'b0),
            .i_enable(i_enable),
            .o_sreg(o_sreg_unused));

    initial begin
        logic [63:0] count_to;

        if (!$value$plusargs("count=%0d", count_to)) begin
            count_to = 10;
        end

        `log_info(("Count to: %0d", count_to));

        i_enable <= 1'b1;
        @(posedge clock);

        for (; |count_to; count_to --) begin
            `log_info(("n: %0d, reg: %0h", count_to, u_lfsr.sreg));
            @(posedge clock);
        end

        `log_info(("Stop at: %0h", u_lfsr.sreg));

        repeat(10) @(posedge clock);
        $finish;
    end

    initial
      if ($test$plusargs ("dump")) begin
          $dumpfile("lfsr_tb.fst");
          $dumpvars(0, lfsr_tb);
      end

endmodule // lfsr_tb
