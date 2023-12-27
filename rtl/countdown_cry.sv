`timescale 1ps/1ps
`default_nettype none

module countdown_cry #(parameter COUNT = 16)
  (input wire clock,
   input wire i_reset,
   input wire i_enable,
   output reg o_done);

    localparam WIDTH = $clog2(COUNT);
    logic [WIDTH:0] cntr;

    always_ff @(posedge clock)
      if (i_reset)
        cntr <= (COUNT-1);
      else
        if (i_enable && !o_done)
          cntr <= cntr - 1'b1;

    assign o_done = cntr[WIDTH];

endmodule // countdown_cry
