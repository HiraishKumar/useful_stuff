module fixed_128_add(
    input signed [127:0] a_in,    // Input operand A (Q56.8 format)
    input signed [127:0] b_in,    // Input operand B (Q56.8 format)
    output signed [127:0] sum,  // sum P (Q120.8 format)
    output logic overflow,        // Flag for overflow detection
    output logic underflow_q       // Flag for underflow detection (going below minimum negative)
);

    assign sum = a_in + b_in;

    // Positive overflow: (a_in > 0 and b_in > 0 and sum < 0)
    assign overflow = (a_in[127] == 1'b0) && (b_in[127] == 1'b0) && (sum[127] == 1'b1);

    // Negative underflow: (a_in < 0 and b_in < 0 and sum > 0)
    assign underflow_q = (a_in[127] == 1'b1) && (b_in[127] == 1'b1) && (sum[127] == 1'b0);

endmodule

