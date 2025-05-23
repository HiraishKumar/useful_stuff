module FixedPointAddSub(
    input signed [31:0] a_in,      // Input operand A (Q16.16)
    input signed [31:0] b_in,      // Input operand B (Q16.16)
    input               sub_n_add, // Control signal: 0 for Add, 1 for Subtract
    output signed [31:0] sum_diff_out, // Result (A+B or A-B) (Q16.16)
    output logic         overflow    // Flag for overflow detection
);
    wire signed [32:0] temp_result_wide; // 1 bit extra wide to deetect overflow 

    assign temp_result_wide = (sub_n_add == 1'b1) ?
                              ($signed({1'b0, a_in}) - $signed({1'b0, b_in})) : // if 1 then Subtraction
                              ($signed({1'b0, a_in}) + $signed({1'b0, b_in})); // else Addition

    // Assign the lower 32 bits of the wide result to the output
    assign sum_diff_out = temp_result_wide[31:0];

    // Overflow detection
    assign overflow = (temp_result_wide[32] != sum_diff_out[31]);

endmodule