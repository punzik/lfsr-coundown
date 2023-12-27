`timescale 1ps/1ps

`include "pkg_lfsr_cntr.svh"

`ifdef VERILATOR
 `define log_info(msg)  begin $display({$sformatf msg}); end
 `define log_warn(msg)  begin $display({$sformatf msg}); end
 `define log_fail(msg)  begin $display({$sformatf msg}); end
`else
 `include "hut.svh"
`endif

module lfsr_cntr;
    initial begin
        logic [63:0] count_to;
        logic [63:0] poly;

        if (!$value$plusargs("count=%0d", count_to)) begin
            count_to = 10;
        end

        poly = pkg_lfsr_cntr::get_poly(count_to);

        if (poly == '0) begin
            `log_fail(("LFSR for %0d not found\n", count_to));
            $finish;
        end

        `log_info(("Count_to: 0x%0d", count_to));
        `log_info(("Polynome: 0x%0h", poly));

        count_to = pkg_lfsr_cntr::mk_lfsr_counter(count_to, poly);

        `log_info(("Stop at: 0x%0h", count_to));
        $finish;
    end
endmodule // lfsr_cntr
