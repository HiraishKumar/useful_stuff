    `include "fixed_32_add_sub.v"

    module fixed_32_cmp(
        input signed [31:0]a,
        input signed [31:0]b,
        output logic res    // Output 1 if b < a
    );

        wire signed [31:0] diff_out;
        wire add_sub_overflow;
        fixed_32_add_sub inst(
            .a_in(a),
            .b_in(b),
            .sub_n_add(1'b1),
            .diff_out(diff_out),
            .overflow(add_sub_overflow)
        );

        assign res = diff_out > 32'd0
    endmodule