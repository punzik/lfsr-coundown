package pkg_lfsr_cntr;

    localparam TAPS_COUNT = 62;
    localparam TAPS_SIZE = TAPS_COUNT * (64 + 8);
    localparam logic [TAPS_SIZE-1:0] taps = {8'd3, 64'h6,
                                             8'd4, 64'hc,
                                             8'd5, 64'h14,
                                             8'd6, 64'h30,
                                             8'd7, 64'h60,
                                             8'd8, 64'hb8,
                                             8'd9, 64'h110,
                                             8'd10, 64'h240,
                                             8'd11, 64'h500,
                                             8'd12, 64'h829,
                                             8'd13, 64'h100d,
                                             8'd14, 64'h2015,
                                             8'd15, 64'h6000,
                                             8'd16, 64'hd008,
                                             8'd17, 64'h12000,
                                             8'd18, 64'h20400,
                                             8'd19, 64'h40023,
                                             8'd20, 64'h90000,
                                             8'd21, 64'h140000,
                                             8'd22, 64'h300000,
                                             8'd23, 64'h420000,
                                             8'd24, 64'he10000,
                                             8'd25, 64'h1200000,
                                             8'd26, 64'h2000023,
                                             8'd27, 64'h4000013,
                                             8'd28, 64'h9000000,
                                             8'd29, 64'h14000000,
                                             8'd30, 64'h20000029,
                                             8'd31, 64'h48000000,
                                             8'd32, 64'h80200003,
                                             8'd33, 64'h100080000,
                                             8'd34, 64'h204000003,
                                             8'd35, 64'h500000000,
                                             8'd36, 64'h801000000,
                                             8'd37, 64'h100000001f,
                                             8'd38, 64'h2000000031,
                                             8'd39, 64'h4400000000,
                                             8'd40, 64'ha000140000,
                                             8'd41, 64'h12000000000,
                                             8'd42, 64'h300000c0000,
                                             8'd43, 64'h63000000000,
                                             8'd44, 64'hc0000030000,
                                             8'd45, 64'h1b0000000000,
                                             8'd46, 64'h300003000000,
                                             8'd47, 64'h420000000000,
                                             8'd48, 64'hc00000180000,
                                             8'd49, 64'h1008000000000,
                                             8'd50, 64'h3000000c00000,
                                             8'd51, 64'h6000c00000000,
                                             8'd52, 64'h9000000000000,
                                             8'd53, 64'h18003000000000,
                                             8'd54, 64'h30000000030000,
                                             8'd55, 64'h40000040000000,
                                             8'd56, 64'hc0000600000000,
                                             8'd57, 64'h102000000000000,
                                             8'd58, 64'h200004000000000,
                                             8'd59, 64'h600003000000000,
                                             8'd60, 64'hc00000000000000,
                                             8'd61, 64'h1800300000000000,
                                             8'd62, 64'h3000000000000030,
                                             8'd63, 64'h6000000000000000,
                                             8'd64, 64'hd800000000000000};

    function automatic logic [63:0] get_poly(logic [63:0] count_to);
        logic [63:0] poly = '0;
        logic [71:0] tap;
        int nn;

        for (int n = 0; n < TAPS_COUNT; n ++) begin
            tap = taps[n * 72 +: 72];
            nn = int'(tap[64 +: 8]);
            if (count_to < ((64'b1 << nn) - 1))
              poly = tap[63:0];
        end

        return poly;
    endfunction

    function automatic logic [63:0] mk_lfsr_counter(logic [63:0] count_to,
                                                    logic [63:0] lfsr_poly);
        logic [63:0] sreg;
        logic [63:0] msb = 1 << ($clog2(lfsr_poly) - 1);

        for (sreg = '0; |count_to; count_to = count_to - 1'b1)
          sreg = sreg[0] ? (sreg >> 1) | msb : ((sreg >> 1) ^ lfsr_poly) & ~msb;

        return sreg;
    endfunction

endpackage // pkg_lfsr_cntr
