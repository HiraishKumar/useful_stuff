module gradient_func(
    input signed [31:0] offset,
    input signed [31:0]x,
    output signed [31:0]res
);
    assign res = (x - offset) << 1;  // 2*(x - OFFSET) {Slope of (x - OFFSET)^2}
endmodule