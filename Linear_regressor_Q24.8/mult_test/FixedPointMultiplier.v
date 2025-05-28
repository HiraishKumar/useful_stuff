// FixedPointMultiplier.v
module FixedPointMultiplier(
    input signed [31:0] a_in,    // Input operand A (Q16.16 format)
    input signed [31:0] b_in,    // Input operand B (Q16.16 format)
    output signed [31:0] p_out,  // Product P (Q16.16 format)
    output logic overflow        // Flag for overflow detection
);

    localparam integer FRACT_BITS = 16;
    wire signed [63:0] product_full;

    assign product_full = a_in * b_in;
    assign p_out = product_full >>> FRACT_BITS;

    assign overflow = (product_full[63:32] != {{32{p_out[31]}}});

endmodule