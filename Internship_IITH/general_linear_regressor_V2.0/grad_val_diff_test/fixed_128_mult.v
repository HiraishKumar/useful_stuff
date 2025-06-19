module fixed_128_mult(
    input signed [127:0] a_in,    // Input operand A (Q56.8 format)
    input signed [127:0] b_in,    // Input operand B (Q56.8 format)
    output signed [127:0] p_out,  // Product P (Q120.8 format)
    output logic overflow,        // Flag for overflow detection
    output logic underflow_q       // Flag for underflow detection (going below minimum negative)
);

    localparam integer FRACT_BITS = 8;
    wire signed [255:0] product_full;

    assign product_full = a_in * b_in;
    assign p_out = product_full [127 + FRACT_BITS : FRACT_BITS];

    wire expected_sign = product_full[127 + FRACT_BITS];; // The sign bit of the result
    wire [255 : 127 + FRACT_BITS + 1] higher_bits = product_full[255 : 127 + FRACT_BITS + 1];
    assign overflow = (!expected_sign) && (|higher_bits);
    assign underflow_q = (expected_sign) && (~(&higher_bits)); // &higher_bits checks if all bits are 1
endmodule

