`timescale 1ps/1ps
`include "hut.svh"

/* verilator lint_off INITIALDLY */

`ifndef COUNTDOWN_MODULE
 `define COUNTDOWN_MODULE countdown
`endif

module lfsr_countdown_tb;
    logic clock = 1'b0;
    logic reset = 1'b1;
    initial forever #(10ns/2) clock = ~clock;

    parameter COUNT = 100;
    parameter TRIES = 4;

    logic i_reset;
    logic i_enable;
    logic o_done;
    logic ref_done;
    assign i_reset = reset;

    `COUNTDOWN_MODULE #(.COUNT(COUNT)) DUT (.*);
    countdown_ref #(.COUNT(COUNT)) REF (.o_done(ref_done), .*);

    initial forever begin
        @(posedge clock);

        if (!i_reset)
          assert(ref_done === o_done)
            else begin
                `log_fail(("Count fail at %0t", $time()));
                repeat(10) @(posedge clock);
                $finish;
            end
    end

    logic enable_man;
    logic enable_rnd;
    int try = 0;

    always_ff @(posedge clock)
      enable_rnd <= try[0] ? 1'($urandom) : 1'b1;

    assign i_enable = enable_man & enable_rnd;

    initial begin
        enable_man <= 1'b0;

        `log_info(("Count to %0d", COUNT));

        for (; try < TRIES; try ++) begin

            reset <= 1'b1; @(posedge clock);
            reset <= 1'b0; @(posedge clock);

            repeat(10) @(posedge clock);
            enable_man <= 1'b1;

            while(o_done !== 1'b1) @(posedge clock);

            repeat(10) @(posedge clock);
        end

        try = 0;
        for (int n = 0; n <= COUNT; n += 1) begin
            assert (o_done === 1'b1)
              else begin
                  `log_fail(("Free running at %0t", $time()));
                  repeat(10) @(posedge clock);
                  $finish;
              end

            @(posedge clock);
        end

        $finish;
    end

    initial
      if ($test$plusargs ("dump")) begin
          $dumpfile("lfsr_countdown_tb.fst");
          $dumpvars(0, lfsr_countdown_tb);
      end

endmodule // lfsr_countdown_tb
