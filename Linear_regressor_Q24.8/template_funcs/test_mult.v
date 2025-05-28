module Fixed_Point_Multiplier(
    input signed [31:0] a_in,    // Input operand A (Q16.16 format)
    input signed [31:0] b_in,    // Input operand B (Q16.16 format)
    output signed [31:0] p_out,  // Product P (Q16.16 format)
    output logic overflow        // Flag for overflow detection
);

    // Define the fractional bits for Q16.16 format
    // This is crucial for the right-shift amount.
    localparam integer FRACT_BITS = 16;

    // Intermediate full-precision product
    // When multiplying two N-bit numbers, the product can be up to 2*N bits.
    // For two 32-bit signed numbers, the product can be 64 bits.
    wire signed [63:0] product_full;

    // Step 1: Perform integer multiplication
    // Verilog automatically extends signed operands to the width of the largest operand
    // before multiplication if the result is assigned to a wider wire.
    // So, `a_in` and `b_in` are effectively treated as 32-bit signed integers,
    // and their multiplication will produce a 64-bit signed integer result.
    assign product_full = a_in * b_in;

    // Step 2: Right-shift to re-scale for fixed-point
    // For Q(I.F) * Q(J.G) = Q(I+J.F+G)
    // If both are Q16.16, the full product is effectively Q32.32.
    // To get back to Q16.16, we need to effectively divide by 2^16,
    // which is a right shift by FRACT_BITS (16).
    // This performs truncation, effectively dropping the lower FRACT_BITS.
    assign p_out = product_full >>> FRACT_BITS; // Arithmetic right shift

    // Step 3: Overflow Detection
    // Check if any of the bits that were shifted out from the integer part of the desired
    // Q16.16 format (i.e., bits [63:32] of the 64-bit product) indicate an overflow
    // into the sign bit or beyond the integer range of a 32-bit Q16.16 number.
    // A simplified overflow check:
    // The desired output is 32 bits (p_out). If the actual product_full requires
    // more than 32 bits for its integer part after scaling, or if it crosses the
    // boundary for signed 32-bit representation, then overflow occurs.
    // In Q16.16, the most significant bit of the integer part is bit 31.
    // The actual integer part from product_full is product_full[63:FRACT_BITS].
    // We are fitting this into 32 bits (p_out[31:0]).
    // Bits product_full[63:32] represent the integer part beyond the desired 16 bits.
    // If any of these higher bits are different from the sign bit of the intended result,
    // it implies an overflow.
    assign overflow = (p_out[31] != product_full[63]) || // Sign bit mismatch
                      (p_out[31] ? (|product_full[63:32] & ~p_out[31]) : (|product_full[63:32] & p_out[31]));

    // A more robust overflow check can be complex, especially with signed numbers.
    // A common simplified approach is to check if the sign extension region of the
    // full product matches the sign bit of the truncated result.
    // Example simplified overflow (may not cover all edge cases):
    // assign overflow = (product_full[63:32] != {{32{p_out[31]}}});
    // This checks if the upper 32 bits are all identical to the sign bit of the lower 32 bits.
    // If not, then there's an overflow. Let's use this simpler and more robust one for now.
    assign overflow = (product_full[63:32] != {{32{p_out[31]}}});


endmodule