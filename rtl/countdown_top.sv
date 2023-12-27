`timescale 1ps/1ps
`default_nettype none

// In vivado run in TCL console:
// set_param synth.elaboration.rodinMoreOptions "rt::set_parameter max_loop_limit 200000000"

//`define TRIVIAL
//`define TRIVIAL_WITH_CARRY

module countdown_top
  (input wire clock,
   input wire i_reset,
   input wire i_enable,
   output reg o_done);

    logic reset_v, enable_v, done_v;
    always_ff @(posedge clock) begin
        reset_v <= i_reset;
        enable_v <= i_enable;
        o_done <= done_v;
    end

`ifdef TRIVIAL
    countdown_ref #(.COUNT(64'd30_000_000_000))
`elsif TRIVIAL_WITH_CARRY
    countdown_cry #(.COUNT(64'd30_000_000_000))
`else
    // Count to: 30_000_000_000
    // Polynome: 0x500000000
    // Stop at: 0xb7b32de0
    countdown #(.COUNT(64'd30_000_000_000),
                .POLY(64'h500000000),
                .STOP(64'hb7b32de0))
`endif
    u_countdown
      (.clock,
       .i_reset(reset_v),
       .i_enable(enable_v),
       .o_done(done_v));

endmodule // countdown_top
