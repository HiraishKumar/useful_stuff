module fixed_128_mult(
    input signed [63:0] a_in,    // Input operand A (Q56.8 format)
    input signed [63:0] b_in,    // Input operand B (Q56.8 format)
    output signed [127:0] p_out,  // Product P (Q120.8 format)
    output logic overflow,        // Flag for overflow detection
    output logic underflow_q       // Flag for underflow detection (going below minimum negative)
);

    localparam integer FRACT_BITS = 8;
    wire signed [127:0] product_full;

    assign product_full = a_in * b_in;
    assign p_out = product_full >>> FRACT_BITS;

    wire expected_sign = p_out[127]; // The sign bit of the result
    wire [119:0] msb_of_product_full = product_full[63:40]; // 63 - 40 + 1 = 24 bits    
    assign overflow = 1'b0;
    assign underflow_q = 1'b0;
endmodule

