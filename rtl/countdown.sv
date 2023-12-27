`timescale 1ps/1ps
`default_nettype none

`include "pkg_lfsr_cntr.svh"

module countdown #(parameter COUNT = 100,
                   parameter POLY = 0,
                   parameter STOP = 0)
    (input wire clock,

     input wire i_reset,
     input wire i_enable,
     output reg o_done);

    localparam LFSR_POLY = (POLY == 0) ? pkg_lfsr_cntr::get_poly(COUNT-3) : POLY;
    localparam LFSR_SIZE = $clog2(LFSR_POLY);
    localparam [LFSR_SIZE-1:0] STOP_COUNT =
                               (STOP == 0) ?
                               LFSR_SIZE'(pkg_lfsr_cntr::mk_lfsr_counter(COUNT-3, LFSR_POLY)) :
                               STOP;

    logic lfsr_enable;
    logic [LFSR_SIZE-1:0] lfsr_sreg;

    assign lfsr_enable = i_enable;

    lfsr #(.POLY(LFSR_POLY))
    u_lfsr (.clock(clock),
            .i_reset(i_reset),
            .i_enable(lfsr_enable),
            .o_sreg(lfsr_sreg));

    localparam PDONE_W = 5;
    localparam PDONE_COUNT =
               (LFSR_SIZE % PDONE_W) == 0 ?
               LFSR_SIZE / PDONE_W :
               LFSR_SIZE / PDONE_W + 1;

    logic [PDONE_COUNT-1:0] pdone;

    for (genvar n = 0; n < PDONE_COUNT; n += 1) begin : pdone_assign
        localparam L = n * PDONE_W;
        localparam H = (((n+1) * PDONE_W) >= LFSR_SIZE ?
                        LFSR_SIZE : (n+1) * PDONE_W) - 1;

        always_ff @(posedge clock)
          pdone[n] <= i_reset ? 1'b0 : (lfsr_sreg[H:L] == STOP_COUNT[H:L]) & i_enable;
    end

    logic pdone_latch0;
    logic pdone_latch1;
    logic done;

    always_ff @(posedge clock)
      if (i_reset) pdone_latch0 <= 1'b0;
      else if (&pdone) pdone_latch0 <= 1'b1;

    always_ff @(posedge clock)
      if (i_reset) pdone_latch1 <= 1'b0;
      else if ((&pdone || pdone_latch0) && i_enable) pdone_latch1 <= 1'b1;

    always_ff @(posedge clock)
      if (i_reset) done <= 1'b0;
      else if (pdone_latch1 && i_enable) done <= 1'b1;

    assign o_done = done;

endmodule // countdown
