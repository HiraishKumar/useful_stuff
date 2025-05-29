module gradient_func(
    input signed [31:0] offset,
    input signed [31:0]x,
    output signed [31:0]res,
    output logic overflow
);
    wire [31:0] diff_out;
    assign diff_out = x - offset;
    assign overflow = diff_out[31] != diff_out[30];
    assign res = diff_out << 1;  // 2*(x - OFFSET) {Slope of (x - OFFSET)^2}
endmodule