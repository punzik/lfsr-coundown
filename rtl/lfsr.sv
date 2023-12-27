`timescale 1ps/1ps
`default_nettype none

module lfsr #(parameter POLY = 16'b1101_0000_0000_1000,
              localparam SIZE = $clog2(POLY))
    (input wire clock,
     input wire i_reset,
     input wire i_enable,
     output wire [SIZE-1:0] o_sreg);

    logic [SIZE-1:0] sreg = '0;
    logic feedback;

    assign feedback = sreg[0];
    assign o_sreg = sreg;

    always_ff @(posedge clock)
      if (i_reset)
        sreg <= '0;
      else
        if (i_enable) begin
            sreg[SIZE-1] <= feedback;

            for (int i = 1; i < SIZE; i += 1)
              sreg[i-1] <= POLY[i-1] ? ~(sreg[i] ^ feedback) : sreg[i];
        end

endmodule // lfsr
