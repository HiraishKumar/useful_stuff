`include "fixed_32_mult.v"

module gradient_func(
    input signed [31:0] offset,
    input signed [31:0]x,
    output signed [31:0]res
);
    assign res = (x - offset) << 1;
endmodule