module fixed_64_mult(
    input signed [31:0] a_in,    // Input operand A (Q24.8 format)
    input signed [31:0] b_in,    // Input operand B (Q24.8 format)
    output signed [55:0] p_out,  // Product P (Q47.8 format)
    output logic overflow        // Flag for overflow detection
);

    localparam integer FRACT_BITS = 8;
    wire signed [63:0] product_full;

    assign product_full = a_in * b_in;
    assign p_out = product_full >>> FRACT_BITS;

    assign overflow = (product_full[63:56] != {8{p_out[63]}});

endmodule

